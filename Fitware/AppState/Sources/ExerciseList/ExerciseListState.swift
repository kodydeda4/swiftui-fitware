import SwiftUI
import ComposableArchitecture
import Failure
import Exercise
import ExerciseListClient

public struct ExerciseListState {
  public var alert: AlertState<ExerciseListAction>?
  public var exercises: IdentifiedArrayOf<ExerciseState>
  public var searchResults: IdentifiedArrayOf<ExerciseState> {
    exercises.search(\.model.name, for: searchText)
      .filter({ bodyparts.isSuperset(of: Set($0.model.bodypart)) })
      .filter({ equipment.contains($0.model.equipment) })
      .filter({ sex.contains($0.model.sex) })
      .filter({ type.contains($0.model.type) })
//      .filter({ primary.isSuperset(of: Set($0.model.primaryMuscles)) })
//      .filter({ secondary.isSuperset(of: Set($0.model.secondaryMuscles)) })

  }
  @BindableState public var searchText: String
  @BindableState public var bodyparts = Set<BodyPart>()//(BodyPart.allCases)
  @BindableState public var equipment = Set<Equipment>(Equipment.allCases)
  @BindableState public var sex       = Set<Sex>(Sex.allCases)
  @BindableState public var type      = Set<ExerciseType>(ExerciseType.allCases)
//  @BindableState public var primary   = Set<Muscle>()//(Muscle.allCases)
//  @BindableState public var secondary = Set<Muscle>()//(Muscle.allCases)
  
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
