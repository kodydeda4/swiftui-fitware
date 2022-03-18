import SwiftUI
import ComposableArchitecture
import App

struct iOS_AppView: View {
  let store: Store<AppState, AppAction> = AppState.defaultStore
  
  var body: some View {
    WithViewStore(store) { viewStore in
      SwitchStore(store) {
        CaseLet(
          state: /AppState.auth,
          action: AppAction.auth,
          then: iOS_AuthView.init(store:)
        )
        CaseLet(
          state: /AppState.user,
          action: AppAction.user,
          then: iOS_UserView.init(store:)
        )
      }
    }
  }
}


// MARK: Previews
struct iOS_AppView_Previews: PreviewProvider {
  static var previews: some View {
    iOS_AppView()
  }
}
