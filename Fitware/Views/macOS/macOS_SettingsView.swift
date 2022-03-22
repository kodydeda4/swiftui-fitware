import SwiftUI
import ComposableArchitecture
import Settings

struct macOS_SettingsView: View {
  let store: Store<SettingsState, SettingsAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      List {
        Text(viewStore.user.displayName ?? "unknown")
        Text(viewStore.user.email ?? "unknown")
      }
      .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
      .navigationTitle("Settings")
      .toolbar {
        Button("Sign out") {
          viewStore.send(.signoutButtonTapped)
        }
      }
    }
  }
}

struct macOS_SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    macOS_SettingsView(store: SettingsState.defaultStore)
  }
}
