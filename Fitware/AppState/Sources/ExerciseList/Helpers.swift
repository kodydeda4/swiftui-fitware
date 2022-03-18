import ComposableArchitecture

extension IdentifiedArrayOf where Element: Identifiable {
  /// Filter by keypath to match search.
  func search(
    _ keyPath: KeyPath<Element, String>,
    for search: String
  ) -> Self {
    filter { element in
      search.isEmpty
      ? true
      : element[keyPath: keyPath].localizedCaseInsensitiveContains(search)
    }
  }
}
