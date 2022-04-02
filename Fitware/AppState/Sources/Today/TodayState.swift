import SwiftUI
import ComposableArchitecture
import Exercise
import ExerciseListClient
import Firebase
import GymVisual

public struct TodayState {
  //  public var user: User
  public var exercises: IdentifiedArrayOf<ExerciseState>
  public var exerciseDescription: String {
    Set(exercises.flatMap(\.model.bodyparts).map(\.rawValue)).joined(separator: ", ")
  }
  
  public init(
    //    user: User = Auth.auth().currentUser!,
    exercises: IdentifiedArrayOf<ExerciseState> = IdentifiedArrayOf(uniqueElements: [
      .bicyclePilates,
      .bicepsLegConcentrationCurlUpperArms,
      .abRollerCrunchWaist,
      .elbowFlexion,
      .aboveHeadChestStretchFemaleChest,
      .archerPullUpBack
    ].map(ExerciseState.init)
    )
  ) {
    //    self.user = user
    self.exercises = exercises
  }
}

public enum TodayAction {
  case binding(BindingAction<TodayState>)
  case exercises(id: ExerciseState.ID, action: ExerciseAction)
}

public struct TodayEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let exerciseListClient: ExerciseListClient
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    exerciseListClient: ExerciseListClient
  ) {
    self.mainQueue = mainQueue
    self.exerciseListClient = exerciseListClient
  }
}

public let todayReducer = Reducer<
  TodayState,
  TodayAction,
  TodayEnvironment
>.combine(
  exerciseReducer.forEach(
    state: \.exercises,
    action: /TodayAction.exercises(id:action:),
    environment: { ExerciseEnvironment(mainQueue: $0.mainQueue) }
  ),
  Reducer { state, action, environment in
    switch action {
      
    case .binding:
      return .none
      
    case .exercises:
      return .none
    }
  }.binding()
)

extension TodayState: Equatable {}
extension TodayAction: Equatable {}
extension TodayAction: BindableAction {}

public extension TodayState {
  static let defaultStore = Store(
    initialState: TodayState(),
    reducer: todayReducer,
    environment: TodayEnvironment(
      mainQueue: .main,
      exerciseListClient: .live
    )
  )
}


