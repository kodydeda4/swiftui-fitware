import ComposableArchitecture
import Failure

public struct ExerciseState {
  public let id: String
  public let name: String
  public let type: String
  public let bodypart: String
  public let equipment: String
  public let gender: String
  public let primaryMuscles: [String]
  public let secondaryMuscles: [String]
  @BindableState public var selected: Bool
  
  public init(
    id: String, name: String, type: String, bodypart: String, equipment: String, gender: String, primaryMuscles: [String], secondaryMuscles: [String], selected: Bool = false) {
    self.id = id
    self.name = name
    self.type = type
    self.bodypart = bodypart
    self.equipment = equipment
    self.gender = gender
    self.primaryMuscles = primaryMuscles
    self.secondaryMuscles = secondaryMuscles
    self.selected = selected
  }
}

public enum ExerciseAction {
  case binding(BindingAction<ExerciseState>)
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
      id: "510112",
      name: "Dumbbell Single Power Clean",
      type: "Strength",
      bodypart: "Weightlifting",
      equipment: "Dumbbell",
      gender: "Male",
      primaryMuscles: ["Adductor Magnus", "Biceps Brachii", "Clavicular Head"],
      secondaryMuscles: [""]
    ),
    reducer: exerciseReducer,
    environment: ExerciseEnvironment(
      mainQueue: .main
    )
  )
}
