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
  @BindableState public var sheet: Bool
  
  public init(
    user: User = Auth.auth().currentUser!,
    workouts: IdentifiedArrayOf<WorkoutState> = [],
    exercises: IdentifiedArrayOf<ExerciseState> = [],
    alert: AlertState<WorkoutListAction>? = nil,
    sheet: Bool = false
  ) {
    self.user = user
    self.workouts = workouts
    self.exercises = exercises
    self.alert = alert
    self.sheet = sheet
  }
}

public enum WorkoutListAction {
  case binding(BindingAction<WorkoutListState>)
  case workouts(id: WorkoutState.ID, action: WorkoutAction)
  case fetchWorkouts
  case clearAll
  case deleteWorkouts([WorkoutState])
  case fetchWorkoutsResult(Result<[WorkoutState], Failure>)
  case deleteWorkoutResult(Result<String, Failure>)
  case clearAllResult(Result<String, Failure>)
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
      
    case .createWorkout:
      return environment.workoutListClient.createWorkout(
        WorkoutState(
          userID: state.user.uid,
          timestamp: Date(),
          text: "Workout \(state.workouts.count)",
          done: false,
          exercises: [randomExercises.randomElement()!]
        )
      )
      .receive(on: environment.mainQueue)
      .catchToEffect(WorkoutListAction.createWorkoutResult)
      
    case let .createWorkoutResult(.success(message)):
      //state.alert = AlertState(title: TextState(message))
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
      
    case .clearAll:
      return environment.workoutListClient.removeWorkout(Array(state.workouts))
        .receive(on: environment.mainQueue)
        .catchToEffect(WorkoutListAction.deleteWorkoutResult)
      
    case .clearAllResult:
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
