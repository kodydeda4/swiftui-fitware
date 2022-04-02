import Foundation

public struct ExerciseSet: Identifiable, Codable, Hashable, Equatable {
  public let id: UUID
  public var weight: Int
  public var reps: Int
  public var complete: Bool = false
  public var previousWeight: Int?
  public var previousReps: Int?
}
