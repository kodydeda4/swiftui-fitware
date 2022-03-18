import ComposableArchitecture
import Failure
import Firebase
import AuthClient

public struct SettingsState {
  public var user: User
  
  public init(user: User = Auth.auth().currentUser!) {
    self.user = user
  }
}

public enum SettingsAction {
  case binding(BindingAction<SettingsState>)
  case signoutButtonTapped
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
