import Combine
import ComposableArchitecture
import IdentifiedCollections
import Firebase
import Failure
import Exercise
import ExerciseListClient
import Workout
import WorkoutListClient

public struct WorkoutListState {
  public let user: User
  public var workouts: IdentifiedArrayOf<WorkoutState>
  public var exercises: IdentifiedArrayOf<ExerciseState>
  public var alert: AlertState<WorkoutListAction>?
  
  public init(
    user: User = Auth.auth().currentUser!,
    workouts: IdentifiedArrayOf<WorkoutState> = [],
    exercises: IdentifiedArrayOf<ExerciseState> = [],
    alert: AlertState<WorkoutListAction>? = nil
  ) {
    self.user = user
    self.workouts = workouts
    self.exercises = exercises
    self.alert = alert
  }
}

public enum WorkoutListAction {
  case binding(BindingAction<WorkoutListState>)
  case workouts(id: WorkoutState.ID, action: WorkoutAction)
  case fetchWorkouts
  case deleteWorkouts([WorkoutState])
  case fetchWorkoutsResult(Result<[WorkoutState], Failure>)
  case deleteWorkoutResult(Result<String, Failure>)
  case dismissAlert
  
  // CreateWorkout
  case exercises(id: ExerciseState.ID, action: ExerciseAction)
  case fetchExercises
  case fetchExercisesResult(Result<[ExerciseState], Failure>)
  case createWorkout
  case createWorkoutResult(Result<String, Failure>)
}

public struct WorkoutListEnvironment {
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

public let workoutListReducer = Reducer<
  WorkoutListState,
  WorkoutListAction,
  WorkoutListEnvironment
>.combine(
  exerciseReducer.forEach(
    state: \.exercises,
    action: /WorkoutListAction.exercises(id:action:),
    environment: {
      ExerciseEnvironment(
        mainQueue: $0.mainQueue
      )
    }
  ),
  Reducer { state, action, environment in
    switch action {
      
    case .fetchExercises:
      return environment.exerciseClient.fetchExercises()
        .receive(on: environment.mainQueue)
        .catchToEffect(WorkoutListAction.fetchExercisesResult)
      
    case let .fetchExercisesResult(.success(success)):
      state.exercises = IdentifiedArrayOf(uniqueElements: success)
      return .none
      
    case let .fetchExercisesResult(.failure(error)):
      return .none
      
      //Workout(userID: Auth.auth().currentUser!.uid, timestamp: Date()
    case .createWorkout:
      return environment.workoutListClient.createWorkout(
        WorkoutState(
          userID: state.user.uid,
          timestamp: Date(),
          text: "Workout \(state.workouts.count)",
          done: false
        )
      )
      .receive(on: environment.mainQueue)
      .catchToEffect(WorkoutListAction.createWorkoutResult)
      
    case let .createWorkoutResult(.success(message)):
      state.alert = AlertState(title: TextState(message))
      return .none
      
    case let .createWorkoutResult(.failure(error)):
      state.alert = AlertState(title: TextState(error.localizedDescription))
      return .none
      
    case .fetchWorkouts:
      return environment.workoutListClient.fetchWorkouts()
        .receive(on: environment.mainQueue)
        .catchToEffect(WorkoutListAction.fetchWorkoutsResult)
      
    case let .fetchWorkoutsResult(.success(success)):
      state.workouts = IdentifiedArrayOf(uniqueElements: success)
      return .none
      
    case let .fetchWorkoutsResult(.failure(error)):
      state.alert = AlertState(title: TextState(error.localizedDescription))
      return .none
      
    case let .workouts(id, .deleteButtonTapped):
      return Effect(value: .deleteWorkouts([state.workouts[id: id]!]))
      
    case let .deleteWorkouts(workouts):
      return environment.workoutListClient.removeWorkout(workouts)
        .receive(on: environment.mainQueue)
        .catchToEffect(WorkoutListAction.deleteWorkoutResult)
    
    case .deleteWorkoutResult(.success):
      return .none
      
    case let .deleteWorkoutResult(.failure(error)):
      state.alert = AlertState(title: TextState(error.localizedDescription))
      return .none
      
    case .exercises:
      return .none
      
    case .workouts:
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
      workoutListClient: .live
    )
  )
}
