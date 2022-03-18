import Firebase
import Combine
import ComposableArchitecture
import Failure

public struct AuthClient {
  public let signInEmailPassword :  (_ email: String, _ password: String) -> Effect<User, Failure>
  public let signInApple         :  (SignInWithAppleToken) -> Effect<User, Failure>
  public let signInAnonymously   :  () -> Effect<User, Failure>
}

public extension AuthClient {
  static let live = Self(
    signInEmailPassword: { email, password in
      Effect
        .task { try await Auth.auth().signIn(withEmail: email, password: password) }
        .map(\.user)
        .mapError(Failure.init)
        .eraseToEffect()
    },
    signInApple: { token in
      Effect.task { try await Auth.auth().signIn(with: OAuthProvider.credential(
        withProviderID: "apple.com",
        idToken: token.appleID,
        rawNonce: token.nonce
      )) }
      .map(\.user)
      .mapError(Failure.init)
      .eraseToEffect()
    },
    signInAnonymously: {
      Effect
        .task { try await Auth.auth().signInAnonymously() }
        .map(\.user)
        .mapError(Failure.init)
        .eraseToEffect()
    }
  )
}
