import SwiftUI
import ComposableArchitecture
import Failure
import Exercise
import ExerciseListClient

public struct ExerciseListState {
  public var inFlight: Bool
  public var alert: AlertState<ExerciseListAction>?
  public var exercises: IdentifiedArrayOf<ExerciseState>
  @BindableState public var query: ExerciseListQuery
  @BindableState public var sheet: Bool
  
  public init(
    inFlight: Bool = false,
    alert: AlertState<ExerciseListAction>? = nil,
    exercises: IdentifiedArrayOf<ExerciseState> = [],
    query: ExerciseListQuery = .init(),
    sheet: Bool = false
  ) {
    self.inFlight = inFlight
    self.alert = alert
    self.exercises = exercises
    self.query = query
    self.sheet = sheet
  }
}

public enum ExerciseListAction {
  case binding(BindingAction<ExerciseListState>)
  case exercises(id: ExerciseState.ID, action: ExerciseAction)
  case updateQuery
  case updateQueryResult(Result<[ExerciseState], Never>)
  case dismissAlert
  case fetchExercises
  case fetchExercisesResult(Result<[Exercise], Failure>)
}

public struct ExerciseListEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let exerciseClient: ExerciseListClient
  
  public init(mainQueue: AnySchedulerOf<DispatchQueue>, exerciseClient: ExerciseListClient) {
    self.mainQueue = mainQueue
    self.exerciseClient = exerciseClient
  }
}

public let exerciseListReducer = Reducer<
  ExerciseListState,
  ExerciseListAction,
  ExerciseListEnvironment
>.combine(
  exerciseReducer.forEach(
    state: \.exercises,
    action: /ExerciseListAction.exercises(id:action:),
    environment: { ExerciseEnvironment(mainQueue: $0.mainQueue) }
  ),
  Reducer { state, action, environment in
    switch action {
      
    case .binding:
      state.inFlight = true
      return Effect(value: .updateQuery)

    case .fetchExercises:
      guard state.exercises.isEmpty else { return .none }
      return environment.exerciseClient.fetchExercises()
        .receive(on: environment.mainQueue)
        .catchToEffect(ExerciseListAction.fetchExercisesResult)
      
    case let .fetchExercisesResult(.success(success)):
      state.exercises = IdentifiedArrayOf(uniqueElements: success.map(ExerciseState.init))
      return .none
      
    case let .fetchExercisesResult(.failure(error)):
      state.alert = AlertState(title: TextState(error.localizedDescription))
      return .none
      
    case .updateQuery:
      return environment.exerciseClient.search(state.exercises, state.query)
        .receive(on: environment.mainQueue)
        .catchToEffect(ExerciseListAction.updateQueryResult)
      
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

extension ExerciseListState: Equatable {}
extension ExerciseListAction: Equatable {}
extension ExerciseListAction: BindableAction {}

public extension ExerciseListState {
  static let defaultStore = Store(
    initialState: ExerciseListState(),
    reducer: exerciseListReducer,
    environment: ExerciseListEnvironment(
      mainQueue: .main,
      exerciseClient: .live
    )
  )
}

extension IdentifiedArrayOf where Element: Identifiable {
  /// Filter by keypath to match search.
  func search(
    _ keyPath: KeyPath<Element, String>,
    for search: String
  ) -> Self {
    filter { element in
      search.isEmpty
      ? true
      : element[keyPath: keyPath].localizedCaseInsensitiveContains(search)
    }
  }
}
