import Combine
import ComposableArchitecture
import IdentifiedCollections
import Exercise
import Failure
import ExerciseListClient
import WorkoutClient

public struct WorkoutListState {
  public var exercises: IdentifiedArrayOf<ExerciseState>
  public var alert: AlertState<WorkoutListAction>?

  public init(
    exercises: IdentifiedArrayOf<ExerciseState> = [],
    alert: AlertState<WorkoutListAction>? = nil
  ) {
    self.exercises = exercises
    self.alert = alert
  }
}

public enum WorkoutListAction {
  case binding(BindingAction<WorkoutListState>)
  case exercises(id: ExerciseState.ID, action: ExerciseAction)
  case load
  case didLoad(Result<[ExerciseState], Failure>)
  case createWorkout
  case didCreateWorkout(Result<Never, Failure>)
  case dismissAlert
}

public struct WorkoutListEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let exerciseClient: ExerciseListClient
  public let workoutClient: WorkoutClient
  
  public init(mainQueue: AnySchedulerOf<DispatchQueue>, exerciseClient: ExerciseListClient, workoutClient: WorkoutClient) {
    self.mainQueue = mainQueue
    self.exerciseClient = exerciseClient
    self.workoutClient = workoutClient
  }
}

public let workoutListReducer = Reducer<
  WorkoutListState,
  WorkoutListAction,
  WorkoutListEnvironment
>.combine(
  exerciseReducer.forEach(
    state: \.exercises,
    action: /WorkoutListAction.exercises(id:action:),
    environment: { ExerciseEnvironment(mainQueue: $0.mainQueue) }
  ),
  Reducer { state, action, environment in
    switch action {
      
    case .load:
      return environment.exerciseClient.loadJSON()
        .receive(on: environment.mainQueue)
        .catchToEffect(WorkoutListAction.didLoad)
      
    case let .didLoad(.success(success)):
      state.exercises = IdentifiedArrayOf(uniqueElements: success)
      return .none
      
    case let .didLoad(.failure(error)):
      return .none
      
    case .exercises:
      return .none
      
    case .createWorkout:
      return environment.workoutClient.create()
        .receive(on: environment.mainQueue)
        .catchToEffect(WorkoutListAction.didCreateWorkout)
    
    case .didCreateWorkout(.success):
      state.alert = AlertState(title: TextState("Success"))
      return .none
      
    case let .didCreateWorkout(.failure(error)):
      state.alert = AlertState(title: TextState(error.localizedDescription))
      return .none

    case .dismissAlert:
      return .none
      
    case .binding:
      return .none
    }
  }.binding()
)

extension WorkoutListState: Equatable {}
extension WorkoutListAction: Equatable {}
extension WorkoutListAction: BindableAction {}

public extension WorkoutListState {
  static let defaultStore = Store(
    initialState: WorkoutListState(),
    reducer: workoutListReducer,
    environment: WorkoutListEnvironment(
      mainQueue: .main,
      exerciseClient: .live,
      workoutClient: .live
    )
  )
}
