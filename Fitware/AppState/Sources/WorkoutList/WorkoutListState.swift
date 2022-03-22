import Combine
import ComposableArchitecture
import IdentifiedCollections
import Firebase
import Failure
import Exercise
import ExerciseListClient
import Workout
import WorkoutListClient
import CreateWorkout

public struct WorkoutListState {
  public let user: User
  public var workouts: IdentifiedArrayOf<WorkoutState>
  public var createWorkout: CreateWorkoutState?
  public var alert: AlertState<WorkoutListAction>?
  
  public init(
    user: User = Auth.auth().currentUser!,
    workouts: IdentifiedArrayOf<WorkoutState> = [],
    createWorkout: CreateWorkoutState? = nil,
    alert: AlertState<WorkoutListAction>? = nil
  ) {
    self.user = user
    self.workouts = workouts
    self.createWorkout = createWorkout
    self.alert = alert
  }
}

public enum WorkoutListAction {
  case binding(BindingAction<WorkoutListState>)
  case createWorkout(CreateWorkoutAction)
  case workouts(id: WorkoutState.ID, action: WorkoutAction)
  case createWorkoutButtonTapped
  
  case fetchWorkouts
  case fetchWorkoutsResult(Result<[WorkoutState], Failure>)
  
  case deleteWorkouts([WorkoutState])
  case deleteWorkoutResult(Result<String, Failure>)
  
  case clearAll
  case clearAllResult(Result<String, Failure>)
  
  case dismissAlert
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
  createWorkoutReducer.optional().pullback(
    state: \.createWorkout,
    action: /WorkoutListAction.createWorkout,
    environment: {
      CreateWorkoutEnvironment(
        mainQueue: $0.mainQueue,
        exerciseClient: $0.exerciseClient,
        workoutListClient: $0.workoutListClient
      )
    }
  ),
  Reducer { state, action, environment in
    switch action {
      
    case .createWorkoutButtonTapped:
      if state.createWorkout == nil {
        state.createWorkout = CreateWorkoutState(user: state.user)
      } else {
        state.createWorkout = nil
      }
      return .none
      
    case .createWorkout(.createWorkoutResult(.success)):
      state.createWorkout = nil
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
      
    case .clearAll:
      return environment.workoutListClient.removeWorkout(Array(state.workouts))
        .receive(on: environment.mainQueue)
        .catchToEffect(WorkoutListAction.deleteWorkoutResult)
      
    case .clearAllResult:
      return .none
            
    case .workouts:
      return .none
      
    case .createWorkout:
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



let randomExercises = [
  ExerciseState(
    id: "556612",
    name: "Sitting Shoulder Press Toe Touch on a padded stool",
    type: "Strength",
    bodypart: "Shoulders",
    equipment: "Body weight",
    gender: "Male",
    target: "",
    synergist: ""
  ),
  ExerciseState(
    id: "556712",
    name: "Sitting Lateral Raise StepOut on a padded stool",
    type: "Strength",
    bodypart: "Shoulders",
    equipment: "Body weight",
    gender: "Male",
    target: "",
    synergist: ""
  ),
  ExerciseState(
    id: "556812",
    name: "Training Level (male)",
    type: "",
    bodypart: "Full body",
    equipment: "Body weight",
    gender: "Male",
    target: "",
    synergist: ""
  ),
  ExerciseState(
    id: "557612",
    name: "Lever One Arm Incline Chest Press (plate loaded)",
    type: "Strength",
    bodypart: "Chest",
    equipment: "Leverage machine",
    gender: "Male",
    target: "",
    synergist: ""
  )
]
