import SwiftUI
import ComposableArchitecture
import Auth
import AuthenticationServices

struct AuthView: View {
  let store: Store<AuthState, AuthAction>
  
  var body: some View {
#if os(iOS)
    iOS
#elseif os(macOS)
    macOS
#endif
  }
}




struct AuthView_Previews: PreviewProvider {
  static var previews: some View {
    AuthView(store: AuthState.defaultStore)
  }
}
