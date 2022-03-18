import Foundation

/// Generic Equatable Error
public struct Failure: Error, Equatable {
  public let localizedDescription: String
  
  public init(_ localizedDescription: String) {
    self.localizedDescription = localizedDescription
  }
  public init(_ error: Error) {
    self.localizedDescription = error.localizedDescription
  }
}
