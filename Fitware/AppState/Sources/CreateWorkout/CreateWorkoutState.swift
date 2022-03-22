import Combine
import ComposableArchitecture
import IdentifiedCollections
import Firebase
import Failure
import Exercise
import ExerciseListClient
import Workout
import WorkoutListClient

public struct CreateWorkoutState {
  public let user: User
  public var exercises: IdentifiedArrayOf<ExerciseState>
  @BindableState public var name: String
  @BindableState public var selection: Set<ExerciseState>
  
  public init(
    user: User = Auth.auth().currentUser!,
    exercises: IdentifiedArrayOf<ExerciseState> = [],
    name: String = "Untitled Workout",
    selection: Set<ExerciseState> = Set()
  ) {
    self.user = user
    self.exercises = exercises
    self.name = name
    self.selection = selection
  }
}

public enum CreateWorkoutAction {
  case binding(BindingAction<CreateWorkoutState>)
  case exercises(id: ExerciseState.ID, action: ExerciseAction)
  case fetchExercises
  case fetchExercisesResult(Result<[ExerciseState], Failure>)
  case createWorkout
  case createWorkoutResult(Result<String, Failure>)
}

public struct CreateWorkoutEnvironment {
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

public let createWorkoutReducer = Reducer<
  CreateWorkoutState,
  CreateWorkoutAction,
  CreateWorkoutEnvironment
>.combine(
  exerciseReducer.forEach(
    state: \.exercises,
    action: /CreateWorkoutAction.exercises(id:action:),
    environment: {
      ExerciseEnvironment(
        mainQueue: $0.mainQueue
      )
    }
  ),
  Reducer { state, action, environment in
    switch action {
      
    case let .exercises(id, .addButtonTapped):
      let exercise = state.exercises[id: id]!
      
      if state.selection.contains(exercise) {
        state.selection.remove(exercise)
      } else {
        state.selection.insert(exercise)
      }
      return .none
      
    case .fetchExercises:
      return environment.exerciseClient.fetchExercises()
        .receive(on: environment.mainQueue)
        .catchToEffect(CreateWorkoutAction.fetchExercisesResult)
      
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
          text: state.name,
          done: false,
          exercises: IdentifiedArrayOf(uniqueElements: state.selection)
        )
      )
      .receive(on: environment.mainQueue)
      .catchToEffect(CreateWorkoutAction.createWorkoutResult)
      
    case .createWorkoutResult:
      return .none
      
    case .exercises:
      return .none
      
    case .binding:
      return .none
    }
  }.binding()
)

extension CreateWorkoutState: Equatable {}
extension CreateWorkoutAction: Equatable {}
extension CreateWorkoutAction: BindableAction {}

public extension CreateWorkoutState {
  static let defaultStore = Store(
    initialState: CreateWorkoutState(),
    reducer: createWorkoutReducer,
    environment: CreateWorkoutEnvironment(
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
