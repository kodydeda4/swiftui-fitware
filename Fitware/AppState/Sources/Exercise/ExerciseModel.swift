public struct ExerciseModel {
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

extension ExerciseModel: Codable {}
extension ExerciseModel: Equatable {}
extension ExerciseModel: Hashable {}
