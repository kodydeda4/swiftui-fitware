import SwiftUI
import ComposableArchitecture
import Settings

struct macOS_SettingsView: View {
  let store: Store<SettingsState, SettingsAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      Text(viewStore.user.displayName ?? "Unknown")
    }
  }
}

struct macOS_SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    macOS_SettingsView(store: SettingsState.defaultStore)
  }
}
