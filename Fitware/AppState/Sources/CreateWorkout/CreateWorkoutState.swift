import Combine
import ComposableArchitecture
import IdentifiedCollections
import Firebase
import Failure
import Exercise
import ExerciseListClient
import Workout
import WorkoutListClient
import GymVisual

public struct CreateWorkoutState {
  public let user: User
  public var inFlight: Bool
  public var alert: AlertState<CreateWorkoutAction>?
  public var exercises: IdentifiedArrayOf<ExerciseState>
//  @BindableState public var query: ExerciseListQuery
  @BindableState public var name: String
  
  public init(
    user: User = Auth.auth().currentUser!,
    inFlight: Bool = false,
    alert: AlertState<CreateWorkoutAction>? = nil,
    exercises: IdentifiedArrayOf<ExerciseState> = [],
//    query: ExerciseListQuery = .init(),
    name: String = "\(UUID.init().description)"
  ) {
    self.user = user
    self.inFlight = inFlight
    self.alert = alert
    self.exercises = exercises
//    self.query = query
    self.name = name
  }
}


public enum CreateWorkoutAction {
  case binding(BindingAction<CreateWorkoutState>)
  case exercises(id: ExerciseState.ID, action: ExerciseAction)
  case updateQuery
  case updateQueryResult(Result<[ExerciseState], Never>)
  case dismissAlert
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
            
    case .createWorkout:
      return environment.workoutListClient.createWorkout(WorkoutState(
        userID: state.user.uid,
        timestamp: Date(),
        text: state.name,
        done: false,
        exercises: IdentifiedArrayOf(uniqueElements: state.exercises.filter(\.selected))
      ))
      .receive(on: environment.mainQueue)
      .catchToEffect(CreateWorkoutAction.createWorkoutResult)

    case .createWorkoutResult:
      return .none
      
    case .binding:
      state.inFlight = true
      return Effect(value: .updateQuery)

    case .fetchExercises:
      guard state.exercises.isEmpty else { return .none }
      return environment.exerciseClient.fetchExercises()
        .receive(on: environment.mainQueue)
        .catchToEffect(CreateWorkoutAction.fetchExercisesResult)
      
    case let .fetchExercisesResult(.success(success)):
      state.exercises = IdentifiedArrayOf(uniqueElements: success)
      return .none
      
    case let .fetchExercisesResult(.failure(error)):
      state.alert = AlertState(title: TextState(error.localizedDescription))
      return .none
      
    case .updateQuery:
      return .none
//      return environment.exerciseClient.search(state.exercises, state.query)
//        .receive(on: environment.mainQueue)
//        .catchToEffect(CreateWorkoutAction.updateQueryResult)
      
    case let .updateQueryResult(.success(values)):
      state.exercises = IdentifiedArrayOf(uniqueElements: values)
      state.inFlight = false
      return .none
      
    case .dismissAlert:
      state.alert = nil
      return .none
      
    case .exercises:
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
