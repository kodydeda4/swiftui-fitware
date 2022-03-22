import SwiftUI
import ComposableArchitecture
import App

struct macOS_AppView: View {
  let store: Store<AppState, AppAction> = AppState.defaultStore
  
  var body: some View {
    WithViewStore(store) { viewStore in
      SwitchStore(store) {
        CaseLet(
          state: /AppState.auth,
          action: AppAction.auth,
          then: macOS_AuthView.init(store:)
        )
        CaseLet(
          state: /AppState.user,
          action: AppAction.user,
          then: macOS_UserView.init(store:)
        )
      }
    }
  }
}


// MARK: Previews
struct macOS_AppView_Previews: PreviewProvider {
  static var previews: some View {
    macOS_AppView()
  }
}
