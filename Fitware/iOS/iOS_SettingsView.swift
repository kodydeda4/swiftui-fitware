import SwiftUI
import ComposableArchitecture
import Settings

struct iOS_SettingsView: View {
  let store: Store<SettingsState, SettingsAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        Form {
          Text(viewStore.user.displayName ?? "unknown")
          Text(viewStore.user.email ?? "unknown")
        }
      }
      .navigationTitle("Settings")
    }
  }
}

struct iOS_SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    iOS_SettingsView(store: SettingsState.defaultStore)
  }
}
