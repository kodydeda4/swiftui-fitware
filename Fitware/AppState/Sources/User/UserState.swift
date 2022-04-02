import SwiftUI
import ComposableArchitecture
import ExerciseList
import ExerciseListClient
import Failure
import Firebase
import WorkoutList
import WorkoutListClient
import Settings
import AuthClient
import Today

public struct UserState {
  public var user: User
  @BindableState public var route: Route?
  public var today: TodayState
  public var exerciseList: ExerciseListState
  public var workoutList: WorkoutListState
  public var settings: SettingsState
  
  public enum Route: Hashable, CaseIterable {
    case today
    case workoutList
    case exerciseList
    case settings
  }
  
  public init(
    user: User = Auth.auth().currentUser!,
    route: Route? = .today,
    today: TodayState = .init(),
    exerciseList: ExerciseListState = .init(),
    workoutList: WorkoutListState = .init(),
    settings: SettingsState = .init()
  ) {
    self.user = user
    self.route = route
    self.today = today
    self.exerciseList = exerciseList
    self.workoutList = workoutList
    self.settings = settings
  }
}

public enum UserAction {
  case binding(BindingAction<UserState>)
  case settings(SettingsAction)
  case today(TodayAction)
  case exerciseList(ExerciseListAction)
  case workoutList(WorkoutListAction)
}

public struct UserEnvironment {
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

public let userReducer = Reducer<
  UserState,
  UserAction,
  UserEnvironment
>.combine(
  exerciseListReducer.pullback(
    state: \.exerciseList,
    action: /UserAction.exerciseList,
    environment: {
      ExerciseListEnvironment(
        mainQueue: $0.mainQueue,
        exerciseClient: $0.exerciseClient
      )
    }
  ),
  workoutListReducer.pullback(
    state: \.workoutList,
    action: /UserAction.workoutList,
    environment: {
      WorkoutListEnvironment(
        mainQueue: $0.mainQueue,
        exerciseClient: $0.exerciseClient,
        workoutListClient: $0.workoutListClient
      )
    }
  ),
  todayReducer.pullback(
    state: \.today,
    action: /UserAction.today,
    environment: {
      TodayEnvironment(
        mainQueue: $0.mainQueue,
        exerciseListClient: $0.exerciseClient
      )
    }
  ),
  settingsReducer.pullback(
    state: \.settings,
    action: /UserAction.settings,
    environment: {
      SettingsEnvironment(
        mainQueue: $0.mainQueue,
        authClient: $0.authClient
      )
    }
  ),
  Reducer { state, action, environment in
    switch action {
      
    case .today, .exerciseList, .workoutList, .settings, .binding:
      return .none
    }
  }.binding()
)

extension UserState: Equatable {}
extension UserAction: Equatable {}
extension UserAction: BindableAction {}

public extension UserState {
  static let defaultStore = Store<UserState, UserAction>(
    initialState: UserState(),
    reducer: userReducer,
    environment: UserEnvironment(
      mainQueue: .main,
      authClient: .live,
      exerciseClient: .live,
      workoutListClient: .live
    )
  )
}
