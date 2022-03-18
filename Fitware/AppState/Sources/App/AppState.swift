import SwiftUI
import ComposableArchitecture
import Firebase
import Failure
import Auth
import User
import ExerciseList
import ExerciseListClient
import AuthClient
import WorkoutListClient

public enum AppState: Equatable {
  case auth(AuthState)
  case user(UserState)
}

public enum AppAction: Equatable {
  case auth(AuthAction)
  case user(UserAction)
}

public struct AppEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let authClient: AuthClient
  public let exerciseClient: ExerciseListClient
  public let workoutListClient: WorkoutListClient
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    authClient: AuthClient,
    exerciseClient: ExerciseListClient,
    workoutListClient: WorkoutListClient
  ) {
    self.mainQueue = mainQueue
    self.authClient = authClient
    self.exerciseClient = exerciseClient
    self.workoutListClient = workoutListClient
  }
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  authReducer.pullback(
    state: /AppState.auth,
    action: /AppAction.auth,
    environment: { AuthEnvironment(mainQueue: $0.mainQueue, authClient: $0.authClient) }
  ),
  userReducer.pullback(
    state: /AppState.user,
    action: /AppAction.user,
    environment: { UserEnvironment(mainQueue: $0.mainQueue, exerciseClient: $0.exerciseClient, workoutListClient: $0.workoutListClient) }
  ),
  Reducer { state, action, environment in
    switch action {
      
    case let .auth(.signInResult(.success(user))):
      state = .user(.init(user: user))
      return .none
      
    case .auth, .user:
      return .none
    }
  }
).debug()

public extension AppState {
  static let defaultStore = Store(
    initialState: AppState.auth(
      AuthState(
        email: "test@email.com",
        password: "123123"
      )),
    reducer: appReducer,
    environment: AppEnvironment(
      mainQueue: .main,
      authClient: .live,
      exerciseClient: .live,
      workoutListClient: .live
    )
  )
}
