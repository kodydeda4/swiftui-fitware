import ComposableArchitecture
import Failure

public struct ExerciseState {
  public let id: String
  public let model: Exercise
  @BindableState public var selected: Bool
  
  public init(
    _ model: Exercise
  ) {
    self.id = model.id
    self.model = model
    self.selected = false
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
    // Update this store, the information is incorrect
    initialState: ExerciseState(
      Exercise(
        id: "551612",
        name: "Lever Reverse Vertical Hack Squat",
        video: URL(string: "https://www.id-design.com/videos/55161201_lever_reverse_vertical_hack_squat_hips.mp4")!,
        sex: .male,
        equipment: .leverageMachine,
        type: .strength,
        bodypart: [
          .hips
        ],
        primaryMuscles: [
          .gluteusMaximus,
          .quadriceps
        ],
        secondaryMuscles: [
          .adductorMagnus,
          .soleus
        ]
      )
    ),
    reducer: exerciseReducer,
    environment: ExerciseEnvironment(
      mainQueue: .main
    )
  )
}
