import SwiftUI
import ComposableArchitecture
import App

struct AppView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      SwitchStore(store) {
        CaseLet(
          state: /AppState.auth,
          action: AppAction.auth,
          then: AuthView.init(store:)
        )
        CaseLet(
          state: /AppState.user,
          action: AppAction.user,
          then: UserView.init(store:)
        )
      }
    }
  }
}


// MARK: Previews
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: AppState.defaultStore)
  }
}
