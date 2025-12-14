//
//  SharedNetworkStatusManager.swift
//  SixLayerFramework
//
//  Shared network status manager to prevent multiple NWPathMonitor instances
//  from stressing configd (system configuration daemon)
//

import Foundation
import Network
import Combine

/// Shared network status manager to prevent multiple NWPathMonitor instances
/// from being created, which could stress the system configuration daemon (configd)
@MainActor
public class SharedNetworkStatusManager: ObservableObject {
    
    // MARK: - Singleton
    
    public static let shared = SharedNetworkStatusManager()
    
    // MARK: - Published Properties
    
    @Published public private(set) var isNetworkAvailable: Bool = true
    
    // MARK: - Private Properties
    
    private var networkMonitor: NWPathMonitor?
    private var networkMonitorQueue: DispatchQueue?
    private var subscribers: Set<AnyCancellable> = []
    private var referenceCount: Int = 0
    private let lock = NSLock()
    
    // MARK: - Initialization
    
    private init() {
        // Private initializer for singleton
    }
    
    // MARK: - Public Methods
    
    /// Start monitoring network connectivity
    /// Returns a publisher that emits network status changes
    /// The publisher will emit the current status immediately, then future updates
    public func startMonitoring() -> AnyPublisher<Bool, Never> {
        lock.lock()
        defer { lock.unlock() }
        
        referenceCount += 1
        
        // If monitor already exists, return publisher for current and future status
        if networkMonitor != nil {
            return $isNetworkAvailable.eraseToAnyPublisher()
        }
        
        // Create shared monitor
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "com.sixlayer.shared.networkmonitor")
        
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.isNetworkAvailable = path.status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
        self.networkMonitor = monitor
        self.networkMonitorQueue = queue
        
        // Set initial network status
        isNetworkAvailable = monitor.currentPath.status == .satisfied
        
        // Return publisher that will emit current status and future updates
        return $isNetworkAvailable.eraseToAnyPublisher()
    }
    
    /// Stop monitoring network connectivity
    /// Should be called when no longer needed (reference counting)
    public func stopMonitoring() {
        lock.lock()
        defer { lock.unlock() }
        
        referenceCount -= 1
        
        // Only stop monitoring when no references remain
        if referenceCount <= 0 {
            networkMonitor?.cancel()
            networkMonitor = nil
            networkMonitorQueue = nil
            referenceCount = 0
        }
    }
    
    /// Get current network status synchronously
    public func currentStatus() -> Bool {
        return isNetworkAvailable
    }
}


