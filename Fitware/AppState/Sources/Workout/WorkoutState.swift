import Firebase
import FirebaseFirestore
import ComposableArchitecture
import FirebaseFirestoreSwift
import Failure
import Combine
import Foundation
import Exercise

public struct WorkoutState {
  @DocumentID public var id: String?
  public let userID: String
  public var timestamp: Date
  public var text: String
  public var done: Bool
  public var exercises: IdentifiedArrayOf<ExerciseState>
  
  public init(
    userID: String,
    timestamp: Date,
    text: String,
    done: Bool,
    exercises: IdentifiedArrayOf<ExerciseState> = []
  ) {
    self.userID = userID
    self.timestamp = timestamp
    self.text = text
    self.done = done
    self.exercises = exercises
  }
}

public enum WorkoutAction {
  case exercises(id: ExerciseState.ID, action: ExerciseAction)
  case deleteButtonTapped
}

public struct WorkoutEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

public let workoutReducer = Reducer<
  WorkoutState,
  WorkoutAction,
  WorkoutEnvironment
>.combine(
  exerciseReducer.forEach(
    state: \.exercises,
    action: /WorkoutAction.exercises(id:action:),
    environment: {
      ExerciseEnvironment(
        mainQueue: $0.mainQueue
      )
    }
  ),
  
  Reducer { state, action, environment in
    switch action {
      
    case .exercises:
      return .none
      
    case .deleteButtonTapped:
      return .none
    }
  }
)

extension WorkoutState: Equatable {}
extension WorkoutState: Identifiable {}
extension WorkoutState: Codable {}
extension WorkoutAction: Equatable {}

public extension WorkoutState {
  static let defaultStore = Store(
    initialState: WorkoutState(
      userID: "",
      timestamp: .now,
      text: "Text",
      done: false,
      exercises: []
    ),
    reducer: workoutReducer,
    environment: WorkoutEnvironment(
      mainQueue: .main
    )
  )
}
