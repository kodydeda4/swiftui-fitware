import Firebase
import FirebaseFirestore
import ComposableArchitecture
import FirebaseFirestoreSwift
import Failure
import Combine
import Foundation

public struct WorkoutState {
  @DocumentID public var id: String?
  public let userID: String
  public var timestamp: Date
  public var text: String
  public var done: Bool
  
  public init(
    userID: String,
    timestamp: Date,
    text: String,
    done: Bool
  ) {
    self.userID = userID
    self.timestamp = timestamp
    self.text = text
    self.done = done
  }
}

public enum WorkoutAction {
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
> { state, action, environment in
  switch action {
    
  case .deleteButtonTapped:
    return .none
  }
}

extension WorkoutState: Equatable {}
extension WorkoutState: Identifiable {}
extension WorkoutState: Codable {}
extension WorkoutAction: Equatable {}
