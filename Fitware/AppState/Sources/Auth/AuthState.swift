import Firebase
import ComposableArchitecture
import AuthenticationServices
import Failure
import AuthClient

public struct AuthState: Equatable {
  @BindableState public var email: String
  @BindableState public var password: String
  
  public init(
    email: String = "",
    password: String = ""
  ) {
    self.email = email
    self.password = password
  }
}

public enum AuthAction: BindableAction, Equatable {
  case binding(BindingAction<AuthState>)
  case signInAnonymously
  case signInWithEmail
  case signInWithApple(SignInWithAppleToken)
  case signInResult(Result<Firebase.User, Failure>)
}

public struct AuthEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let authClient: AuthClient
  
  public init(mainQueue: AnySchedulerOf<DispatchQueue>, authClient: AuthClient) {
    self.mainQueue = mainQueue
    self.authClient = authClient
  }
}

public let authReducer = Reducer<
  AuthState,
  AuthAction,
  AuthEnvironment
> { state, action, environment in
  
  switch action {
    
  case .binding:
    return .none
    
  case .signInAnonymously:
    return environment.authClient.signInAnonymously()
      .receive(on: environment.mainQueue)
      .catchToEffect(AuthAction.signInResult)
    
  case .signInWithEmail:
    return environment.authClient.signInEmailPassword(state.email, state.password)
      .receive(on: environment.mainQueue)
      .catchToEffect(AuthAction.signInResult)
    
  case let .signInWithApple(credential):
    return environment.authClient.signInApple(credential)
      .receive(on: environment.mainQueue)
      .catchToEffect(AuthAction.signInResult)

        
  case .signInResult(.success):
    return .none
    
  case let .signInResult(.failure(error)):
    return .none
  }
}
.binding()

public extension AuthState {
  static let defaultStore = Store(
    initialState: AuthState(),
    reducer: authReducer,
    environment: AuthEnvironment(
      mainQueue: .main,
      authClient: .live
    )
  )
}
