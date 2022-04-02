import SwiftUI
import ComposableArchitecture
import Exercise
import ExerciseListClient
import Firebase
import GymVisual
import Failure

public struct TodayState {
  //  public var user: User
  public var exercises: IdentifiedArrayOf<ExerciseState>
  public var complete: Bool { exercises.filter { !$0.complete }.isEmpty }
  public var alert: AlertState<TodayAction>?
  public var exerciseDescription: String {
    Set(
      exercises
        .flatMap(\.bodyparts)
        .map(\.rawValue)
    )
    .joined(separator: ", ")
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
    ].map(ExerciseState.init))
    
  ) {
    //    self.user = user
    self.exercises = exercises
  }
}

public enum TodayAction {
  case binding(BindingAction<TodayState>)
  case exercises(id: ExerciseState.ID, action: ExerciseAction)
  case submitButtonTapped
  case submit
  case submitResult(Result<String, Failure>)
  case dismissAlert
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
      
    case .submitButtonTapped:
      if state.complete {
        return Effect(value: .submit)
      } else {
        state.alert = AlertState(
          title: TextState("Are you sure?"),
          message: TextState("You still have some unfinished exercises!"),
          primaryButton: .default(
            TextState("Yes"),
            action: .send(.submit)
          ),
          secondaryButton: .cancel(
            TextState("Cancel"),
            action: .send(.dismissAlert)
          )
        )
      }
      return .none
      
    case .submit:
      return .none
      
    case .submitResult:
      return .none
      
    case .dismissAlert:
      state.alert = nil
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


