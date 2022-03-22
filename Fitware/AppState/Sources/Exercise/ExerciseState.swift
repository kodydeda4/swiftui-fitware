import ComposableArchitecture
import Failure

public struct ExerciseState {
  public let id: String
  public let name: String
  public let type: String
  public let bodypart: String
  public let equipment: String
  public let gender: String
  public let target: String
  public let synergist: String
  
  public init(id: String, name: String, type: String, bodypart: String, equipment: String, gender: String, target: String, synergist: String) {
    self.id = id
    self.name = name
    self.type = type
    self.bodypart = bodypart
    self.equipment = equipment
    self.gender = gender
    self.target = target
    self.synergist = synergist
  }
}

public enum ExerciseAction {
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
  case .addButtonTapped:
    return .none
  }
}

extension ExerciseState: Codable {}
extension ExerciseState: Identifiable {}
extension ExerciseState: Equatable {}
extension ExerciseState: Hashable {}
extension ExerciseAction: Equatable {}

public extension ExerciseState {
  static let defaultStore = Store(
    initialState: ExerciseState(
      id: "510112",
      name: "Dumbbell Single Power Clean",
      type: "Strength",
      bodypart: "Weightlifting",
      equipment: "Dumbbell",
      gender: "Male",
      target: "Adductor Magnus, Biceps Brachii, Clavicular Head",
      synergist: ""
    ),
    reducer: exerciseReducer,
    environment: ExerciseEnvironment(
      mainQueue: .main
    )
  )
}
