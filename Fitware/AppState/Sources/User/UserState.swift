import SwiftUI
import ComposableArchitecture
import ExerciseList
import ExerciseListClient
import Failure
import Firebase
import WorkoutList
import WorkoutClient

public struct UserState {
  @BindableState public var route: Route?
  public var exerciseList = ExerciseListState()
  public var workout = WorkoutListState()
  public var user: User
  
  
  public enum Route {
    case workout
    case exerciseList
  }
  
  public init(
    route: Route? = .exerciseList,
    exerciseList: ExerciseListState = .init(),
    user: User = Auth.auth().currentUser!
  ) {
    self.route = route
    self.exerciseList = exerciseList
    self.user = user
  }
}

public enum UserAction {
  case binding(BindingAction<UserState>)
  case exerciseList(ExerciseListAction)
  case workout(WorkoutListAction)
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
  workoutListReducer.pullback(state: \.workout, action: /UserAction.workout, environment: {
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
      
    case .workout:
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
