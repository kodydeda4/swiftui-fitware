import ComposableArchitecture
import Failure

public struct ExerciseState {
  public var id: String { model.id }
  public let model: ExerciseModel
  @BindableState public var selected: Bool
  
  public init(
    model: ExerciseModel,
    selected: Bool = false
  ) {
    self.model = model
    self.selected = selected
  }
}

public enum ExerciseAction {
  case binding(BindingAction<ExerciseState>)
  case addButtonTapped
}

public struct ExerciseEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(mainQueue: AnySchedulerOf<DispatchQueue>) {
    self.mainQueue = mainQueue
  }
}

public let exerciseReducer = Reducer<
  ExerciseState,
  ExerciseAction,
  ExerciseEnvironment
> { state, action, environment in
  switch action {
    
  case .binding:
    return .none
    
  case .addButtonTapped:
    return .none
    
  }
}.binding()

extension ExerciseState: Codable {}
extension ExerciseState: Identifiable {}
extension ExerciseState: Equatable {}
extension ExerciseState: Hashable {}
extension ExerciseAction: Equatable {}
extension ExerciseAction: BindableAction {}

public extension ExerciseState {
  static let defaultStore = Store(
    initialState: ExerciseState(
      model: ExerciseModel(
        id: "510112",
        name: "Dumbbell Single Power Clean",
        type: "Strength",
        bodypart: "Weightlifting",
        equipment: "Dumbbell",
        gender: "Male",
        target: "Adductor Magnus, Biceps Brachii, Clavicular Head",
        synergist: ""
      )
    ),
    reducer: exerciseReducer,
    environment: ExerciseEnvironment(
      mainQueue: .main
    )
  )
}
