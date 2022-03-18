//import Firebase
//import FirebaseFirestoreSwift
//import ComposableArchitecture
//
//struct WorkoutState: Equatable, Identifiable, Codable {
//  @DocumentID var id: String?
//  let userID: String
//  var timestamp = Date()
//  var text: String = "Untitled"
//  var done: Bool = false
//}
//
//enum WorkoutAction: Equatable {
//  case setText(String)
//  case setDone
//  case delete
//  case updateAPI
//  case didUpdateAPI(Result<Never, AppError>)
//}
//
//struct WorkoutEnvironment {
//  let mainQueue: AnySchedulerOf<DispatchQueue>
//  let todoClient: TodoClient
//}
//
//let workoutReducer = Reducer<
//  WorkoutState,
//  WorkoutAction,
//  WorkoutEnvironment
//> { state, action, environment in
//  switch action {
//    
//  case let .setText(text):
//    state.text = text
//    return Effect(value: .updateAPI)
//    
//  case .setDone:
//    state.done.toggle()
//    return Effect(value: .updateAPI)
//    
//  case .delete:
//    return environment.todoClient.remove(state)
//      .receive(on: environment.mainQueue)
//      .catchToEffect(TodoAction.didUpdateAPI)
//    
//  case .updateAPI:
//    return environment.todoClient.update(state)
//      .receive(on: environment.mainQueue)
//      .catchToEffect(TodoAction.didUpdateAPI)
//    
//  case let .didUpdateAPI(.failure(error)):
//    print(error.localizedDescription)
//    return .none
//  }
//}.debug()
//
//
//extension WorkoutState {
//  static let defaultStore = Store(
//    initialState: WorkoutState(
//      userID: "Tu87mWuYA3R0XX0vph8RS40IX6g1",
//      timestamp: Date(),
//      text: "Untitled"
//    ),
//    reducer: workoutReducer,
//    environment: WorkoutEnvironment(
//      mainQueue: .main,
//      todoClient: .live
//    )
//  )
//}
