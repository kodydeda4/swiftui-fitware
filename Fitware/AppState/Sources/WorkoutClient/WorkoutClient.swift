import Firebase
import FirebaseFirestore
import ComposableArchitecture
import FirebaseFirestoreSwift
import Failure
import Combine

public struct Workout: Equatable, Identifiable, Codable {
  @DocumentID public var id: String?
  public let userID: String
  public var timestamp = Date()
  public var text: String = "Untitled"
  public var done: Bool = false
}

public struct WorkoutClient {
  public let fetchWorkouts: () -> Effect<[Workout], Failure>
  public let create: () -> Effect<Never, Failure>
  public let remove : ([Workout]) -> Effect<Never, Failure>
}

public extension WorkoutClient {
  static let live = Self(
    fetchWorkouts: {
      Firestore
        .firestore()
        .collection("workouts")
        .whereField("userID", isEqualTo: Auth.auth().currentUser!.uid)
        .snapshotPublisher()
        .map({ $0.documents.compactMap({ try? $0.data(as: Workout.self) }) })
        .mapError(Failure.init)
        .eraseToEffect()
    },
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
    },
    remove: { workouts in
      Effect.future { callback in
        workouts.compactMap(\.id).forEach {
          Firestore
            .firestore()
            .collection("workouts")
            .document($0)
            .delete { if let error = $0 { callback(.failure(.init(error))) } }
        }
      }
    }
  )
}


extension Query {
  func snapshotPublisher(includeMetadataChanges: Bool = false) -> AnyPublisher<QuerySnapshot, Error> {
    let publisher = PassthroughSubject<QuerySnapshot, Error>()
    
    let snapshotListener = addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
      if let error = error {
        publisher.send(completion: .failure(error))
      } else if let snapshot = snapshot {
        publisher.send(snapshot)
      } else {
        fatalError()
      }
    }
    return publisher
      .handleEvents(receiveCancel: snapshotListener.remove)
      .eraseToAnyPublisher()
  }
}
