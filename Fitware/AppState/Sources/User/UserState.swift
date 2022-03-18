import SwiftUI
import ComposableArchitecture
import ExerciseList
import ExerciseListClient
import Failure
import Firebase
import WorkoutList
import WorkoutClient

public struct UserState {
  public var user: User
  @BindableState public var route: Route?
  public var exerciseList = ExerciseListState()
  public var workoutList = WorkoutListState()
  
  public enum Route {
    case workoutList
    case exerciseList
  }
  
  public init(
    user: User = Auth.auth().currentUser!,
    route: Route? = .workoutList,
    exerciseList: ExerciseListState = .init(),
    workoutList: WorkoutListState = .init()
  ) {
    self.user = user
    self.route = route
    self.exerciseList = exerciseList
    self.workoutList = workoutList
  }
}

public enum UserAction {
  case binding(BindingAction<UserState>)
  case exerciseList(ExerciseListAction)
  case workoutList(WorkoutListAction)
}

public struct UserEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let exerciseClient: ExerciseListClient
  public let workoutClient: WorkoutClient
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    exerciseClient: ExerciseListClient,
    workoutClient: WorkoutClient
  ) {
    self.mainQueue = mainQueue
    self.exerciseClient = exerciseClient
    self.workoutClient = workoutClient
  }
}

public let userReducer = Reducer<UserState, UserAction, UserEnvironment>.combine(
  exerciseListReducer.pullback(state: \.exerciseList, action: /UserAction.exerciseList, environment: {
    ExerciseListEnvironment(
      mainQueue: $0.mainQueue,
      exerciseClient: $0.exerciseClient
    )
  }),
  workoutListReducer.pullback(state: \.workoutList, action: /UserAction.workoutList, environment: {
    WorkoutListEnvironment(
      mainQueue: $0.mainQueue,
      exerciseClient: $0.exerciseClient,
      workoutClient: $0.workoutClient
    )
  }),
  Reducer { state, action, environment in
    switch action {
      
    case .exerciseList:
      return .none
      
    case .workoutList:
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
      workoutClient: .live
    )
  )
}
