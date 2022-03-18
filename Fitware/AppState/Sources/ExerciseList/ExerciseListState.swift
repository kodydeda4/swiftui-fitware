import SwiftUI
import ComposableArchitecture
import Failure
import Exercise
import ExerciseListClient

public struct ExerciseListState {
  public var alert: AlertState<ExerciseListAction>?
  public var exercises: IdentifiedArrayOf<ExerciseState>
  public var searchResults: IdentifiedArrayOf<ExerciseState> { exercises.search(\.name, for: searchText) }
  @BindableState public var searchText: String
  
  public init(
    alert: AlertState<ExerciseListAction>? = nil,
    exercises: IdentifiedArrayOf<ExerciseState> = [],
    searchText: String = ""
  ) {
    self.alert = alert
    self.exercises = exercises
    self.searchText = searchText
  }
}

public enum ExerciseListAction {
  case binding(BindingAction<ExerciseListState>)
  case exercises(id: ExerciseState.ID, action: ExerciseAction)
  case save
  case load
  case didSave(Result<Never, Failure>)
  case didLoad(Result<[ExerciseState], Failure>)
  case dismissAlert
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
      
    case .save:
      return environment.exerciseClient.saveJSON(Array(state.exercises))
        .receive(on: environment.mainQueue)
        .catchToEffect(ExerciseListAction.didSave)
      
    case .load:
      return environment.exerciseClient.loadJSON()
        .receive(on: environment.mainQueue)
        .catchToEffect(ExerciseListAction.didLoad)
      
    case let .didLoad(.success(success)):
      state.exercises = IdentifiedArrayOf(uniqueElements: success)
      return .none
      
    case let .didLoad(.failure(error)):
      state.alert = AlertState(title: TextState(error.localizedDescription))
      return .none
      
    case .didSave(.success):
      state.alert = AlertState(title: TextState("Success"))
      return .none
      
    case let .didSave(.failure(error)):
      state.alert = AlertState(title: TextState(error.localizedDescription))
      return .none
      
    case .dismissAlert:
      state.alert = nil
      return .none
      
    case .exercises:
      return .none
      
    case .binding:
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
