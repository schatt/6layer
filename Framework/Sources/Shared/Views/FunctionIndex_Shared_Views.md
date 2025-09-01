# Function Index

- **Directory**: Framework/Sources/Shared/Views
- **Generated**: 2025-09-01 09:02:01 -0700
- **Script**: Scripts/generate_function_index.sh

This index lists function declarations and other Swift declarations found in this directory's Swift files.

Functions are categorized by access level and type for better organization.

Documentation comments are extracted when available.

Extension context is shown for functions that are part of extensions.

---

## Framework/Sources/Shared/Views/FormInsightsDashboard.swift
### Public Interface
- **L13:** ` public var body: some View`
  - *function*
- **L351:** ` public var body: some View`
  - *function*
- **L382:** ` public var body: some View`
  - *function*
- **L400:** ` public var body: some View`
  - *function*
- **L433:** ` public var body: some View`
  - *function*
- **L452:** ` public var body: some View`
  - *function*
- **L480:** ` public var body: some View`
  - *function*
- **L507:** ` public var body: some View`
  - *function*
- **L534:** ` public var body: some View`
  - *function*
- **L564:** ` public var body: some View`
  - *function|extension FormRecommendationPriority*
- **L597:** ` public var body: some View`
  - *function*
- **L624:** ` public var body: some View`
  - *function*

### Internal Methods
- **L419:** ` var color: Color`
  - *function*
- **L547:** ` var color: Color`
  - *function|extension FormRecommendationPriority*
- **L667:** ` var displayName: String`
  - *function*

### Private Implementation
- **L124:** ` private func overviewCards(formId: String) -> some View`
  - *function*
- **L161:** ` private func performanceSection(formId: String) -> some View`
  - *function*
- **L204:** ` private func analyticsSection(formId: String) -> some View`
  - *function*
- **L232:** ` private func errorSection(formId: String) -> some View`
  - *function*
- **L262:** ` private func abTestingSection(formId: String) -> some View`
  - *function*
- **L287:** ` private func recommendationsSection(formId: String) -> some View`
  - *function*
- **L331:** ` private func formatTime(_ timeInterval: TimeInterval) -> String`
  - *function*
- **L68:** ` private var dashboardHeader: some View`
  - *function*
- **L309:** ` private var noFormSelectedView: some View`
  - *function*

## Framework/Sources/Shared/Views/DynamicFormView.swift
### Public Interface
- **L21:** ` public var body: some View`
  - *function*
- **L78:** ` public var body: some View`
  - *function*
- **L110:** ` public var body: some View`
  - *function*
- **L168:** ` public var body: some View`
  - *function*
- **L293:** ` public var body: some View`
  - *function*
- **L326:** ` public var body: some View`
  - *function*
- **L381:** ` public var body: some View`
  - *function*
- **L402:** ` public var body: some View`
  - *function*
- **L419:** ` public var body: some View`
  - *function*
- **L441:** ` public var body: some View`
  - *function*
- **L471:** ` public var body: some View`
  - *function*
- **L496:** ` public var body: some View`
  - *function*
- **L509:** ` public var body: some View`
  - *function*
- **L522:** ` public var body: some View`
  - *function*
- **L539:** ` public var body: some View`
  - *function*
- **L556:** ` public var body: some View`
  - *function*
- **L573:** ` public var body: some View`
  - *function*
- **L589:** ` public var body: some View`
  - *function*
- **L10:** ` public init(`
  - *function*
- **L104:** ` public init(section: DynamicFormSection, formState: DynamicFormState)`
  - *function*

### Private Implementation
- **L55:** ` private func handleSubmit()`
  - *function*
- **L67:** ` private func handleCancel()`
  - *function*
- **L156:** ` private func toggleSection()`
  - *function*
- **L200:** ` private var fieldInput: some View`
  - *function*
- **L344:** ` private var textContentType: UITextContentType?`
  - *function*
- **L359:** ` private var textContentType: String?`
  - *function*

## Framework/Sources/Shared/Views/CrossPlatformNavigation.swift
### Public Interface
- **L383:** `public static func platformEmptyDetailView() -> some View`
  - *static function*
  - *Generate empty detail view\n*
- **L403:** `public static func platformNavigationTitle(analysis: CollectionAnalysisResult) -> String`
  - *static function*
  - *Generate navigation title based on analysis\n*

### Internal Methods
- **L97:** ` static func determineNavigationStrategy(`
  - *static function*
  - *Determine the best navigation strategy based on data analysis and hints\n*

## Framework/Sources/Shared/Views/FormWizardView.swift
### Public Interface
- **L24:** ` public var body: some View`
  - *function*
- **L81:** ` public var body: some View`
  - *function*
- **L123:** ` public var body: some View`
  - *function*
- **L171:** ` public var body: some View`
  - *function*
- **L10:** ` public init(`
  - *function*

### Private Implementation
- **L54:** ` private func handleNext()`
  - *function*
- **L66:** ` private func handlePrevious()`
  - *function*
- **L70:** ` private func handleComplete()`
  - *function*
- **L106:** ` private var progress: FormWizardProgress`
  - *function*
- **L145:** ` private var stepColor: Color`
  - *function*
- **L155:** ` private var stepIcon: some View`
  - *function*

## Framework/Sources/Shared/Views/IntelligentFormView.swift
### Public Interface
- **L474:** ` public var body: some View`
  - *function*

### Private Implementation
- **L106:** ` private static func determineFormStrategy(`
  - *static function*
  - *Determine the best form strategy based on data analysis\n*
- **L310:** ` private static func groupFieldsByType(_ fields: [DataField]) -> [FieldType: [DataField]]`
  - *static function*
  - *Group fields by type for better organization\n*
- **L324:** ` private static func getFieldTypeTitle(_ fieldType: FieldType) -> String`
  - *static function*
  - *Get human-readable title for field type\n*
- **L410:** ` private static func extractFieldValue(from object: Any, fieldName: String) -> Any`
  - *static function*
  - *Extract field value from an object using reflection\n*
- **L423:** ` private static func getDefaultValue(for field: DataField) -> Any`
  - *static function*
  - *Get default value for a field\n*
- **L445:** ` private static func getFieldDescription(for field: DataField) -> String?`
  - *static function*
  - *Get field description based on field characteristics\n*

## Framework/Sources/Shared/Views/ResponsiveContainer.swift
### Public Interface
- **L8:** ` public var body: some View`
  - *function*
- **L15:** ` public static var previews: some View`
  - *static function*

## Framework/Sources/Shared/Views/ResponsiveLayout.swift
### Public Interface
- **L123:** ` public func body(content: Content) -> some View`
  - *function*
- **L58:** ` public var body: some View`
  - *function*
- **L89:** ` public var body: some View`
  - *function*
- **L106:** ` public var body: some View`
  - *function*
- **L207:** ` public var body: some View`
  - *function*
- **L229:** ` public var body: some View`
  - *function*

### Internal Methods
- **L21:** ` static func horizontal(width: CGFloat) -> ScreenSizeClass`
  - *static function*
- **L32:** ` static func vertical(height: CGFloat) -> ScreenSizeClass`
  - *static function*
- **L144:** ` func responsivePadding() -> some View`
  - *function*
- **L151:** ` static func gridColumns(for width: CGFloat, minWidth: CGFloat = 300) -> [GridItem]`
  - *static function*
- **L52:** ` init(columns: [GridItem], spacing: CGFloat = 16, @ViewBuilder content: @escaping () -> Content)`
  - *function*
- **L73:** ` init(title: String, subtitle: String, icon: String, color: Color)`
  - *function*
- **L85:** ` init(@ViewBuilder content: @escaping (Bool) -> Content)`
  - *function*
- **L101:** ` init(spacing: CGFloat = 16, @ViewBuilder content: @escaping () -> Content)`
  - *function*

### Private Implementation
- **L127:** ` private var paddingValue: CGFloat`
  - *function*

## Framework/Sources/Shared/Views/IntelligentDetailView.swift
### Public Interface
- **L365:** `public static func platformFieldView(`
  - *static function*
- **L390:** `public static func platformDetailedFieldView(`
  - *static function*
- **L439:** `public static func platformDefaultFieldValue(field: DataField, value: Any) -> some View`
  - *static function*

### Internal Methods
- **L92:** ` static func determineLayoutStrategy(`
  - *static function*
  - *Determine the best layout strategy based on data analysis and hints\n*
- **L532:** ` static func groupFieldsByType(_ fields: [DataField]) -> [FieldType: [DataField]]`
  - *static function*
  - *Group fields by type for better organization\n*
- **L546:** ` static func prioritizeFields(_ fields: [DataField]) -> [FieldPriority: [DataField]]`
  - *static function*
  - *Prioritize fields for detailed view\n*
- **L561:** ` static func determineFieldPriority(_ field: DataField) -> FieldPriority`
  - *static function*
  - *Determine field priority for display\n*

