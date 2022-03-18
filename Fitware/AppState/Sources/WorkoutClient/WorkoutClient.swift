import Firebase
import FirebaseFirestore
import ComposableArchitecture
import FirebaseFirestoreSwift
import Failure

public struct Workout: Equatable, Identifiable, Codable {
  @DocumentID public var id: String?
  public let userID: String
  public var timestamp = Date()
  public var text: String = "Untitled"
  public var done: Bool = false
}

public struct WorkoutClient {
//  let fetch  : ()            -> Effect<[Workout], AppError>
  public let create: () -> Effect<Never, Failure>
//  let remove : ([TodoState]) -> Effect<Never, AppError>
}

public extension WorkoutClient {
  static let live = Self(
//    fetch: {
//      Firestore
//        .firestore()
//        .collection("todos")
//        .whereField("userID", isEqualTo: Auth.auth().currentUser!.uid)
//        .snapshotPublisher()
//        .map({ $0.documents.compactMap({ try? $0.data(as: TodoState.self) }) })
//        .mapError(AppError.init)
//        .eraseToEffect()
//    },
    create: {
      Effect.future { callback in
        do {
          let _ = try Firestore
            .firestore()
            .collection("workouts")
            .addDocument(from: Workout(userID: Auth.auth().currentUser!.uid, timestamp: Date()))
        } catch {
          callback(.failure(.init(error)))
        }
      }
    }
//    remove: { todos in
//      Effect.future { callback in
//        todos.compactMap(\.id).forEach {
//          Firestore
//            .firestore()
//            .collection("todos")
//            .document($0)
//            .delete { if let error = $0 { callback(.failure(.init(error))) } }
//        }
//      }
//    }
  )
}
