import ComposableArchitecture
import Failure
import GymVisual

public struct ExerciseState {
  public let id: Int
  public let model: Exercise
  @BindableState public var selected: Bool
  @BindableState public var exerciseSets = [
    ExerciseSet(weight: 35, reps: 16, complete: false, previousWeight: 20, previousReps: 10),
    ExerciseSet(weight: 45, reps: 14, complete: false),
    ExerciseSet(weight: 50, reps: 20, complete: false),
    ExerciseSet(weight: 25, reps: 12, complete: false),
  ]
  
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
    initialState: ExerciseState(.doorwayBicepsCurlUpperArms),
    reducer: exerciseReducer,
    environment: ExerciseEnvironment(
      mainQueue: .main
    )
  )
}

public extension Exercise {
  var photo: URL {
    URL(string: "https://www.id-design.com/previews_640_360/\(media).jpg")!
  }
  var video: URL {
    URL(string: "https://www.id-design.com/videos/\(media).mp4")!
  }
}



// MARK: Temporary
public struct ExerciseSet: Identifiable, Codable, Hashable, Equatable {
  public let id = UUID()
  public var weight: Int
  public var reps: Int
  public var complete: Bool
  public var previousWeight: Int?
  public var previousReps: Int?
}
