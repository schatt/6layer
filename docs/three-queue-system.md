# Three-Queue Build System Architecture

## Overview

The CarManager build system uses a sophisticated three-queue architecture to manage the coordination and execution of build tasks. This system separates concerns between task coordination (managing dependencies and child relationships) and task execution (actually running the tasks).

## The Three Queues

### 1. RPP (Ready to Process Parents)
- **Purpose**: Nodes that are ready to coordinate their children
- **Content**: BuildNode objects waiting for parent approval and coordination eligibility
- **State**: Nodes in this queue are in 'pending' status
- **Behavior**: **RPP is unordered** - not a FIFO queue, any node can be processed next
- **Processing**: **RPP is currently single-threaded** - coordination phase processes nodes sequentially, but this is an implementation choice, not an architectural requirement

### 2. GR (Groups Ready)
- **Purpose**: Coordination marker queue - nodes that can coordinate their children
- **Content**: Hash mapping of node keys to presence (1 = present, undef = absent)
- **State**: Nodes copied here during coordination phase
- **Behavior**: Nodes are **copied** here from RPP (they stay in RPP) (they are removed when a node FAILS.)

### 3. Ready
- **Purpose**: Execution queue - nodes ready for immediate execution
- **Content**: BuildNode objects that have completed all dependencies and children
- **State**: Nodes ready to execute or send notifications
- **Behavior**: Nodes are **moved** here from RPP (removed from RPP)
- **Processing**: **Execution phase is multi-threaded** - parallel processing happens from the Ready queue

## Queue Flow Architecture

```
RPP (Ready to Process Parents) - Currently single-threaded coordination
    ↓ [COPY - nodes stay in RPP]
GR (Groups Ready) - Coordination marker
    ↓ [MOVE - nodes removed from RPP]
Ready (Execution Queue) - Multi-threaded execution
```

## The Main Loop

The system operates in a main loop that continues until RPP is empty or stalled:

```
LOOP: while (RPP not empty AND not stalled) {
    Phase 1: Coordination (RPP → GR)
    Phase 2: Execution Preparation (RPP → Ready)  
    Phase 3: Execution (Ready → Done/Failed)
}
```

### Phase 1: Coordination Phase
- **Goal**: Identify nodes ready to coordinate their children
- **Action**: Copy eligible nodes from RPP to GR
- **Result**: Nodes exist in both RPP and GR simultaneously
- **Purpose**: Mark nodes as coordination-eligible while keeping them available for further processing
- **Processing**: **Currently sequential** - coordination phase processes nodes one at a time, but this is an implementation choice that could be parallelized in the future

**Optimization**: When a node goes to GR, if it has an auto-generated dependency group, that dependency group automatically goes to GR as well.

### Phase 2: Execution Preparation Phase
- **Goal**: Move nodes ready for execution to the Ready queue (they must already be in GR)
- **Action**: Move nodes from RPP to Ready (removing them from RPP)
- **Result**: Nodes are removed from RPP and added to Ready
- **Purpose**: Mark nodes as ready for actual execution
- **Processing**: **Sequential** - execution preparation processes nodes one at a time

### Phase 3: Execution Phase
- **Goal**: Execute nodes that are ready
- **Action**: Execute nodes from the Ready queue
- **Result**: Nodes complete execution and move to Done/Failed status
- **Purpose**: Actually run the build tasks
- **Processing**: **Parallel** - execution phase runs multiple nodes simultaneously

## Key Architectural Principles

### "Nodes are Nodes" Principle
- **Every node follows the exact same lifecycle** regardless of type
- **All nodes follow RPP → GR → Ready → Done with identical logic**
- **Unified behavior** across all node types
- **Only special case**: Auto dependency groups get `child_id = 0` and must complete before other children

### Dependency Groups as Coordination Gates
- **Act as coordination gates that must open first**
- **Must complete before other children can proceed**
- **Enable cascading unblocking** of downstream nodes

### Cascading Unblocking
- **Moving to GR enables downstream nodes** but they may still wait for dependencies
- **Coordination phase**: Sequential, unblocks children and dependencies
- **Execution phase**: Parallel, actual task running

## Example Flow with the "all" Group

Let's trace through a complete example using the "all" group from the build configuration:

### **Iteration 1:**
- **Phase 1**: `all` moves to GR (can coordinate, no external dependencies)
  - **Optimization**: `all_dependency_group` automatically moves to GR (parent `all` in GR)
- **Phase 2**: `all_dependency_group` moves to Ready (parent `all` in GR, node `all_dependency_group` in GR)
- **Phase 3**: `all_dependency_group` executes and completes (no-op, empty dependency group)

### **Iteration 2:**
- **Phase 1**: `mac` and `ios` move to GR (parent `all` in GR, dependency group complete)
  - **Optimization**: `mac_dependency_group` and `ios_dependency_group` automatically move to GR
- **Phase 2**: `mac_dependency_group` and `ios_dependency_group` move to Ready (parents in GR, nodes in GR)
- **Phase 3**: Both dependency groups execute and complete (no-ops)

### **Iteration 3:**
- **Phase 1**: `check-git-clean` (mac) moves to GR (parent `mac` in GR, dependency group complete)
- **Phase 2**: `check-git-clean` (mac) moves to Ready (parent `mac` in GR, node `check-git-clean` in GR)
- **Phase 3**: `check-git-clean` (mac) executes and completes

### **Iteration 4:**
- **Phase 1**: `macOS_change_tracking` AND `iOS_change_tracking` move to GR (parents `mac` and `ios` in GR, dependency groups complete, `check-git-clean` complete)
- **Phase 2**: `macOS_change_tracking` AND `iOS_change_tracking` move to Ready (parents in GR, nodes in GR)
- **Phase 3**: `macOS_change_tracking` AND `iOS_change_tracking` execute and complete (parallel execution)

### **Iteration 5:**
- **Phase 1**: `increment-build` (macOS) AND `increment-build` (iOS) move to GR (parents `mac` and `ios` in GR, change tracking complete)
- **Phase 2**: `increment-build` (macOS) AND `increment-build` (iOS) move to Ready (parents in GR, nodes in GR)
- **Phase 3**: Both `increment-build` tasks execute and complete

## Key Implementation Details

### Copy vs Move Operations
```perl
# Coordination Phase: COPY to GR (stays in RPP)
add_to_groups_ready($node_key);  # Adds to %groups_ready_nodes

# Execution Phase: MOVE to Ready (removes from RPP)
move_rpp_to_ready($index);       # Removes from @ready_pending_parent_nodes, adds to @ready_queue_nodes
```

### Queue State Tracking
- **RPP**: Array of BuildNode objects (`@ready_pending_parent_nodes`)
- **GR**: Hash of node keys (`%groups_ready_nodes`)
- **Ready**: Array of BuildNode objects (`@ready_queue_nodes`)

### Node Eligibility Checks
1. **Dependencies satisfied**: All parent dependencies completed
2. **Notifiers satisfied**: All notification conditions met
3. **Parent ready**: Parent group is in GR
4. **Should coordinate next**: Sequential ordering allows coordination

## Common Misunderstandings

### ❌ Wrong: "RPP is a FIFO queue"
- **Reality**: RPP is unordered - any node can be processed next
- **Reason**: Coordination phase processes nodes based on readiness, not order

### ❌ Wrong: "RPP processes nodes in parallel"
- **Reality**: RPP is currently single-threaded - coordination phase processes nodes sequentially
- **Reason**: This is the current implementation choice; coordination could theoretically be parallelized if dependency integrity can be maintained

### ❌ Wrong: "Execution happens from GR"
- **Reality**: Execution happens from Ready queue - GR is just a coordination marker
- **Reason**: GR marks nodes as coordination-complete, Ready marks them as execution-ready

### ❌ Wrong: "Nodes should be removed from RPP when added to GR"
- **Reality**: Nodes are copied to GR and stay in RPP
- **Reason**: RPP maintains processing list during coordination

### ❌ Wrong: "GR is an execution queue"
- **Reality**: GR is a coordination queue
- **Reason**: Nodes in GR coordinate children but don't execute until all their children complete

### ❌ Wrong: "Nodes move directly from GR to Ready"
- **Reality**: Nodes move from RPP to Ready (GR is just a marker)
- **Reason**: RPP is the source queue, GR is just a coordination flag

### ❌ Wrong: "Dependency groups automatically go to Ready"
- **Reality**: Dependency groups must go to GR first, then to Ready, then execute
- **Reason**: Every node follows the same RPP → GR → Ready → Execute lifecycle

## Debugging the System

### When Things Go Wrong
1. **Nodes stuck in RPP**: Check coordination eligibility conditions
2. **Nodes not moving to GR**: Verify `should_coordinate_next` logic
3. **Nodes not moving to Ready**: Check `is_ready_for_execution` conditions

### Key Debug Points
- **Coordination Phase**: Look for "copied to groups_ready" messages
- **Execution Phase**: Look for "moved to ready queue" messages
- **Queue Sizes**: Monitor RPP, GR, and Ready counts

## Architectural Insights

### Elegant Unified Design
The system now accurately reflects the elegant, unified design where:
- **The only special case** is the dependency group priority system
- **Everything else follows the "nodes are nodes" principle**
- **Coordination and execution are cleanly separated**
- **Current sequential coordination** maintains dependency integrity (implementation choice)
- **Parallel execution maximizes performance**
- **Future optimization potential**: Coordination phase could be parallelized if dependency integrity can be maintained

### Dependency Group Optimization
- **When a node goes to GR**, its auto-generated dependency group automatically goes to GR
- **Eliminates extra iterations** - dependency groups move to GR immediately when their parent does
- **Faster coordination** - no waiting for dependency groups to be discovered and moved separately
- **Cleaner logic** - when a node can coordinate, its dependency group is immediately available

This architecture ensures that coordination and execution are properly separated while maintaining the correct processing order and state management, with a clear understanding that coordination is sequential and execution is parallel.

