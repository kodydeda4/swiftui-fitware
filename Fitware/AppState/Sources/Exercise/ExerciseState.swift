import ComposableArchitecture
import Failure
import GymVisual

public struct ExerciseState {
  public let id: Int
  public let name: String
  public let photo: URL
  public let video: URL
  public let sex: Sex
  public let type: ExerciseType
  public let equipment: Equipment
  public let bodyparts: [BodyPart]
  public let primaryMuscles: [Muscle]
  public let secondaryMuscles: [Muscle]
  public var complete: Bool { exerciseSets.filter { !$0.complete}.isEmpty }
  @BindableState public var selected: Bool
  @BindableState public var favorite: Bool
  @BindableState public var exerciseSets = [
    ExerciseSet(weight: 35, reps: 16, previousWeight: 20, previousReps: 10),
    ExerciseSet(weight: 45, reps: 14),
    ExerciseSet(weight: 50, reps: 20),
    ExerciseSet(weight: 25, reps: 12),
  ]
  
  public init(
    _ model: Exercise
  ) {
    self.id = model.id
    self.name = model.name
    self.sex = model.sex
    self.type = model.type
    self.equipment = model.equipment
    self.bodyparts = model.bodyparts
    self.primaryMuscles = model.primaryMuscles
    self.secondaryMuscles = model.secondaryMuscles
    self.photo = URL(string: "https://www.id-design.com/previews_640_360/\(model.media).jpg")!
    self.video = URL(string: "https://www.id-design.com/videos/\(model.media).mp4")!
    self.selected = false
    self.favorite = false
  }
}

public enum ExerciseAction {
  case binding(BindingAction<ExerciseState>)
  case addSet
  case removeSet(ExerciseSet)
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
    
  case .addSet:
    state.exerciseSets += [ExerciseSet(weight: 35, reps: 16)]
    return .none
    
  case let .removeSet(set):
    if let idx = state.exerciseSets.firstIndex(of: set) {
      state.exerciseSets.remove(at: idx)
    }
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
    initialState: ExerciseState(.doorwayBicepsCurlUpperArms),
    reducer: exerciseReducer,
    environment: ExerciseEnvironment(
      mainQueue: .main
    )
  )
}

