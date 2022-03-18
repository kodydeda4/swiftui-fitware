import SwiftUI
import ComposableArchitecture
import ExerciseList
import ExerciseListClient
import Failure
import Firebase
import WorkoutList
import WorkoutListClient
import Settings

public struct UserState {
  public var user: User
  @BindableState public var route: Route?
  public var exerciseList: ExerciseListState
  public var workoutList: WorkoutListState
  public var settings: SettingsState
  
  public enum Route {
    case workoutList
    case exerciseList
    case settings
  }
  
  public init(
    user: User = Auth.auth().currentUser!,
    route: Route? = .workoutList,
    exerciseList: ExerciseListState = .init(),
    workoutList: WorkoutListState = .init(),
    settings: SettingsState = .init()
  ) {
    self.user = user
    self.route = route
    self.exerciseList = exerciseList
    self.workoutList = workoutList
    self.settings = settings
  }
}

public enum UserAction {
  case binding(BindingAction<UserState>)
  case exerciseList(ExerciseListAction)
  case workoutList(WorkoutListAction)
  case settings(SettingsAction)
}

public struct UserEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let exerciseClient: ExerciseListClient
  public let workoutListClient: WorkoutListClient
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    exerciseClient: ExerciseListClient,
    workoutListClient: WorkoutListClient
  ) {
    self.mainQueue = mainQueue
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
  Reducer { state, action, environment in
    switch action {
      
    case .exerciseList:
      return .none
      
    case .workoutList:
      return .none
      
    case .settings:
      return .none
      
    case .binding:
      return .none
    }
  }.binding()
)

extension UserState: Equatable {}
extension UserAction: Equatable {}
extension UserAction: BindableAction {}

public extension UserState {
  static let defaultStore = Store(
    initialState: UserState(),
    reducer: userReducer,
    environment: UserEnvironment(
      mainQueue: .main,
      exerciseClient: .live,
      workoutListClient: .live
    )
  )
}
