import SwiftUI
import ComposableArchitecture
import Auth
import AuthenticationServices

struct macOS_AuthView: View {
  let store: Store<AuthState, AuthAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          
        }
        .listStyle(.sidebar)
        
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
        .onAppear { viewStore.send(.signInCachedUser) }
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

struct macOS_AuthView_Previews: PreviewProvider {
  static var previews: some View {
    macOS_AuthView(store: AuthState.defaultStore)
  }
}
