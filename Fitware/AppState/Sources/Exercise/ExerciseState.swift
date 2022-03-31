import ComposableArchitecture
import Failure
import GymVisual

public struct ExerciseState {
  public let id: Int
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
