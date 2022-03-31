import Exercise
import GymVisual

public struct ExerciseListQuery {
  public var searchText: String
  public var bodyparts: Set<BodyPart>
  public var equipment: Set<Equipment>
  public var sex: Set<Sex>
  public var type: Set<ExerciseType>
  public var primary: Set<Muscle>
  public var secondary: Set<Muscle>
  
  public init(
    searchText: String = String(),
    bodyparts: Set<BodyPart> = Set<BodyPart>(BodyPart.allCases),
    equipment: Set<Equipment> = Set<Equipment>(Equipment.allCases),
    sex: Set<Sex> = Set<Sex>(Sex.allCases),
    type: Set<ExerciseType> = Set<ExerciseType>(ExerciseType.allCases),
    primary: Set<Muscle> = Set<Muscle>(Muscle.allCases),
    secondary: Set<Muscle> = Set<Muscle>(Muscle.allCases)
  ) {
    self.searchText = searchText
    self.bodyparts = bodyparts
    self.equipment = equipment
    self.sex = sex
    self.type = type
    self.primary = primary
    self.secondary = secondary
  }
}

extension ExerciseListQuery: Equatable {}
