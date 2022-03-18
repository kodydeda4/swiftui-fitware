import SwiftUI
import ComposableArchitecture
import ExerciseList
import ExerciseListClient
import Failure
import Firebase

public struct UserState {
  @BindableState public var route: Route?
  public var exerciseList = ExerciseListState()
  public var user: User

  
  public enum Route {
    case exerciseList
  }
  
  public init(
    route: Route? = .exerciseList,
    exerciseList: ExerciseListState = .init(),
    user: User = Auth.auth().currentUser!
  ) {
    self.route = route
    self.exerciseList = exerciseList
    self.user = user
  }
}

public enum UserAction {
  case binding(BindingAction<UserState>)
  case exerciseList(ExerciseListAction)
}

public struct UserEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let exerciseClient: ExerciseListClient
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    exerciseClient: ExerciseListClient
  ) {
    self.mainQueue = mainQueue
    self.exerciseClient = exerciseClient
  }
}

public let userReducer = Reducer<UserState, UserAction, UserEnvironment>.combine(
  exerciseListReducer.pullback(
    state: \.exerciseList,
    action: /UserAction.exerciseList,
    environment: {
      ExerciseListEnvironment(
        mainQueue: $0.mainQueue,
        exerciseClient: $0.exerciseClient
      )
    }
  ),
  Reducer { state, action, environment in
    switch action {
      
    case .exerciseList:
      return .none
      
    case .binding:
      return .none
    }
  }.binding()
)

extension UserState: Equatable {}
extension UserAction: Equatable {}
extension UserAction: BindableAction {}

public extension UserState {
  static let defaultStore = Store(
    initialState: UserState(),
    reducer: userReducer,
    environment: UserEnvironment(
      mainQueue: .main,
      exerciseClient: .live
    )
  )
}
