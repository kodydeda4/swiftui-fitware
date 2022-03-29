import Foundation

public struct Exercise {
  public let id: String
  public let name: String
  public let media: String
  public let sex: Sex
  public let type: ExerciseType
  public let equipment: Equipment
  public let bodyparts: [BodyPart]
  public let primaryMuscles: [Muscle]
  public let secondaryMuscles: [Muscle]

  public init(id: String, name: String, media: String, sex: Sex, type: ExerciseType, equipment: Equipment, bodyparts: [BodyPart], primaryMuscles: [Muscle], secondaryMuscles: [Muscle]) {
    self.id = id
    self.name = name
    self.media = media
    self.sex = sex
    self.type = type
    self.equipment = equipment
    self.bodyparts = bodyparts
    self.primaryMuscles = primaryMuscles
    self.secondaryMuscles = secondaryMuscles
  }
}

public extension Exercise {
  var photo: URL {
    URL(string: "https://www.id-design.com/previews_640_360/\(self.media).jpg")!
  }
  var video: URL {
    URL(string: "https://www.id-design.com/videos/\(self.media).mp4")!
  }
}

public enum Sex: String {
  case male                          = "Male"
  case female                        = "Female"
}

public enum BodyPart: String {
  case waist                         = "Waist"
  case chest                         = "Chest"
  case back                          = "Back"
  case upperArms                     = "Upper Arms"
  case hips                          = "Hips"
  case shoulders                     = "Shoulders"
  case thighs                        = "Thighs"
  case forearms                      = "Forearms"
  case calves                        = "Calves"
  case neck                          = "Neck"
  case cardio                        = "Cardio"
  case plyometrics                   = "Plyometrics"
  case yoga                          = "Yoga"
  case fullBody                      = "Full body"
  case weightlifting                 = "Weightlifting"
  case stretching                    = "Stretching"
  case pilates                       = "Pilates"
}

public enum ExerciseType: String {
  case strength                      = "Strength"
  case aerobic                       = "Aerobic"
  case stretching                    = "Stretching"
}

public enum Equipment: String {
  case bodyWeight                    = "Body weight"
  case leverageMachine               = "Leverage machine"
  case stabilityBall                 = "Stability ball"
  case barbell                       = "Barbell"
  case rope                          = "Rope"
  case cable                         = "Cable"
  case dumbbell                      = "Dumbbell"
  case ezBarbell                     = "EZ Barbell"
  case kettlebell                    = "Kettlebell"
  case medicineBall                  = "Medicine Ball"
  case olympicBarbell                = "Olympic barbell"
  case weighted                      = "Weighted"
  case bosuBall                      = "Bosu ball"
  case sledMachine                   = "Sled machine"
  case smithMachine                  = "Smith machine"
  case wheelRoller                   = "Wheel roller"
  case trapBar                       = "Trap bar"
  case band                          = "Band"
  case suspension                    = "Suspension"
  case assisted                      = "Assisted"
  case resistanceBand                = "Resistance Band"
  case roll                          = "Roll"
  case powerSled                     = "Power Sled"
  case vibratePlate                  = "Vibrate Plate"
  case battlingRope                  = "Battling Rope"
  case rollball                      = "Rollball"
  case Stick                         = "Stick"
}

public enum Muscle: String {
  case wristFlexors                  = "Wrist Flexors"
  case wristExtensors                = "Wrist Extensors"
  case tricepsBrachii                = "Triceps Brachii"
  case trapeziusUpperFibers          = "Trapezius Upper Fibers"
  case trapeziusMiddleFibers         = "Trapezius Middle Fibers"
  case trapeziusLowerFibers          = "Trapezius Lower Fibers"
  case trapezius                     = "Trapezius"
  case transverseAbdominus           = "Transverse Abdominus"
  case tibialisAnterior              = "Tibialis Anterior"
  case teresMinor                    = "Teres Minor"
  case teresMajor                    = "Teres Major"
  case tensorFasciaeLatae            = "Tensor Fasciae Latae"
  case subscapularis                 = "Subscapularis"
  case sternocleidomastoid           = "Sternocleidomastoid"
  case splenius                      = "Splenius"
  case soleus                        = "Soleus"
  case serratusAnterior              = "Serratus Anterior"
  case sartorius                     = "Sartorius"
  case rhomboids                     = "Rhomboids"
  case rectusAbdominis               = "Rectus Abdominis"
  case quadriceps                    = "Quadriceps"
  case pectoralisMajorSternalHead    = "Pectoralis Major Sternal Head"
  case pectoralisMajorClavicularHead = "Pectoralis Major Clavicular Head"
  case pectineous                    = "Pectineous"
  case obliques                      = "Obliques"
  case levatorScapulae               = "Levator Scapulae"
  case latissimusDorsi               = "Latissimus Dorsi"
  case infraspinatus                 = "Infraspinatus"
  case iliopsoas                     = "Iliopsoas"
  case hamstrings                    = "Hamstrings"
  case gracilis                      = "Gracilis"
  case gluteusMinimus                = "Gluteus Minimus"
  case gluteusMedius                 = "Gluteus Medius"
  case gluteusMaximus                = "Gluteus Maximus"
  case gastrocnemius                 = "Gastrocnemius"
  case erectorSpinae                 = "Erector Spinae"
  case deltoidPosterior              = "Deltoid Posterior"
  case deltoidLateral                = "Deltoid Lateral"
  case deltoidAnterior               = "Deltoid Anterior"
  case brachioradialis               = "Brachioradialis"
  case brachialis                    = "Brachialis"
  case bicepsBrachii                 = "Biceps Brachii"
  case adductorMagnus                = "Adductor Magnus"
  case adductorLongus                = "Adductor Longus"
  case adductorBrevis                = "Adductor Brevis"
}

extension Exercise      : Codable, Equatable, Identifiable, Hashable {}
extension BodyPart      : Codable, Equatable, Identifiable, Hashable, CustomStringConvertible, CaseIterable { public var id: String { rawValue }; public var description: String { rawValue } }
extension ExerciseType  : Codable, Equatable, Identifiable, Hashable, CustomStringConvertible, CaseIterable { public var id: String { rawValue }; public var description: String { rawValue } }
extension Equipment     : Codable, Equatable, Identifiable, Hashable, CustomStringConvertible, CaseIterable { public var id: String { rawValue }; public var description: String { rawValue } }
extension Sex           : Codable, Equatable, Identifiable, Hashable, CustomStringConvertible, CaseIterable { public var id: String { rawValue }; public var description: String { rawValue } }
extension Muscle        : Codable, Equatable, Identifiable, Hashable, CustomStringConvertible, CaseIterable { public var id: String { rawValue }; public var description: String { rawValue } }

