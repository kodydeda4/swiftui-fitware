import ComposableArchitecture
import Failure
import Firebase
import AuthClient

public struct SettingsState {
  public var user: User
  public var alert: AlertState<SettingsAction>?
  
  public init(user: User = Auth.auth().currentUser!) {
    self.user = user
  }
}

public enum SettingsAction {
  case binding(BindingAction<SettingsState>)
  case signoutButtonTapped
  case signout
  case signOutResult(Result<String, Failure>)
  case dismissAlert
}

public struct SettingsEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let authClient: AuthClient
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    authClient: AuthClient
  ) {
    self.mainQueue = mainQueue
    self.authClient = authClient
  }
}

public let settingsReducer = Reducer<
  SettingsState,
  SettingsAction,
  SettingsEnvironment
> { state, action, environment in
  switch action {
    
  case .binding:
    return .none
    
  case .signoutButtonTapped:
    state.alert = AlertState(
      title: TextState("Sign Out?"),
      primaryButton: .default(TextState("Confirm"), action: .send(.signout)),
      secondaryButton: .cancel(TextState("Cancel"))
    )
    return .none
    
  case .signout:
    return environment.authClient.signOut()
      .receive(on: environment.mainQueue)
      .catchToEffect(SettingsAction.signOutResult)

  case .signOutResult:
    return .none
  
  case .dismissAlert:
    return .none
    
  }
}.binding()

extension SettingsState: Equatable {}
extension SettingsAction: Equatable {}
extension SettingsAction: BindableAction {}

public extension SettingsState {
  static let defaultStore = Store(
    initialState: SettingsState(),
    reducer: settingsReducer,
    environment: SettingsEnvironment(
      mainQueue: .main,
      authClient: .live
    )
  )
}
