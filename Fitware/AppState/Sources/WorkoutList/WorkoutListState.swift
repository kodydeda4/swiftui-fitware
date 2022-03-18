import Combine
import ComposableArchitecture
import IdentifiedCollections
import Exercise
import Failure
import ExerciseListClient
import WorkoutListClient

public struct WorkoutListState {
  public var workouts: IdentifiedArrayOf<Workout>
  public var exercises: IdentifiedArrayOf<ExerciseState>
  public var alert: AlertState<WorkoutListAction>?

  public init(
    workouts: IdentifiedArrayOf<Workout> = [],
    exercises: IdentifiedArrayOf<ExerciseState> = [],
    alert: AlertState<WorkoutListAction>? = nil
  ) {
    self.workouts = workouts
    self.exercises = exercises
    self.alert = alert
  }
}

public enum WorkoutListAction {
  case dismissAlert
  case binding(BindingAction<WorkoutListState>)
  case exercises(id: ExerciseState.ID, action: ExerciseAction)
  
  case fetchExercises
  case fetchExercisesResult(Result<[ExerciseState], Failure>)
  
  case fetchWorkouts
  case fetchWorkoutsResult(Result<[Workout], Failure>)
  
  case createWorkout
  case createWorkoutResult(Result<Never, Failure>)
}

public struct WorkoutListEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let exerciseClient: ExerciseListClient
  public let workoutListClient: WorkoutListClient
  
  public init(mainQueue: AnySchedulerOf<DispatchQueue>, exerciseClient: ExerciseListClient, workoutListClient: WorkoutListClient) {
    self.mainQueue = mainQueue
    self.exerciseClient = exerciseClient
    self.workoutListClient = workoutListClient
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
      
    case .fetchExercises:
      return environment.exerciseClient.loadJSON()
        .receive(on: environment.mainQueue)
        .catchToEffect(WorkoutListAction.fetchExercisesResult)
      
    case let .fetchExercisesResult(.success(success)):
      state.exercises = IdentifiedArrayOf(uniqueElements: success)
      return .none
      
    case let .fetchExercisesResult(.failure(error)):
      return .none
      
    case .exercises:
      return .none
      
    case .createWorkout:
      return environment.workoutListClient.createWorkout()
        .receive(on: environment.mainQueue)
        .catchToEffect(WorkoutListAction.createWorkoutResult)
    
    case .createWorkoutResult(.success):
      state.alert = AlertState(title: TextState("Success"))
      return .none
      
    case let .createWorkoutResult(.failure(error)):
      state.alert = AlertState(title: TextState(error.localizedDescription))
      return .none

    case .dismissAlert:
      return .none
      
    case .binding:
      return .none
      
    case .fetchWorkouts:
      return environment.workoutListClient.fetchWorkouts()
        .receive(on: environment.mainQueue)
        .catchToEffect(WorkoutListAction.fetchWorkoutsResult)

    case let .fetchWorkoutsResult(.success(success)):
      state.workouts = IdentifiedArrayOf(uniqueElements: success)
      state.alert = AlertState(title: TextState("Success"))
      return .none
      
    case let .fetchWorkoutsResult(.failure(error)):
      state.alert = AlertState(title: TextState(error.localizedDescription))
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
      workoutListClient: .live
    )
  )
}
