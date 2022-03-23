import SwiftUI
import ComposableArchitecture
import AuthenticationServices
import Auth

struct AuthView: View {
  let store: Store<AuthState, AuthAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
#if os(macOS)
        List {}
#endif
        List {
          Section("Email") {
            TextField("Email", text: viewStore.binding(\.$email))
            TextField("Password", text: viewStore.binding(\.$password))
            
            Button("Continue") {
              viewStore.send(.signInWithEmail)
            }
            SignInWithAppleButton() {
              viewStore.send(.signInWithApple($0))
            }
          }
        }
        .navigationTitle("Sign In")
        .onAppear { viewStore.send(.signInCachedUser) }
        .toolbar {
          Button("Guest") {
            viewStore.send(.signInAnonymously)
          }
        }
      }
    }
  }
}

struct AuthView_Previews: PreviewProvider {
  static var previews: some View {
    AuthView(store: AuthState.defaultStore)
  }
}
