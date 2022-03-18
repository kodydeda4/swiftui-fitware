#if os(iOS)
import SwiftUI
import ComposableArchitecture
import Auth
import AuthenticationServices

extension AuthView {
  var iOS: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
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
        .toolbar {
          Button("Guest") {
            viewStore.send(.signInAnonymously)
          }
        }
      }
    }
  }
}

struct AuthView_iOS_Previews: PreviewProvider {
  static var previews: some View {
    AuthView(store: AuthState.defaultStore)
  }
}
#endif
