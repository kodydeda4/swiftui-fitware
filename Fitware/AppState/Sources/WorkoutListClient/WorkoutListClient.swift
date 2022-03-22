import Firebase
import FirebaseFirestore
import ComposableArchitecture
import FirebaseFirestoreSwift
import Failure
import Combine
import Workout

public struct WorkoutListClient {
  public let fetchWorkouts: () -> Effect<[WorkoutState], Failure>
  public let createWorkout: (WorkoutState) -> Effect<String, Failure>
  public let removeWorkout: ([WorkoutState]) -> Effect<String, Failure>
}

public extension WorkoutListClient {
  static let live = Self(
    fetchWorkouts: {
      Firestore
        .firestore()
        .collection("workouts")
        .whereField("userID", isEqualTo: Auth.auth().currentUser!.uid)
        .snapshotPublisher()
        .map({ $0.documents.compactMap({ try? $0.data(as: WorkoutState.self) }) })
        .mapError(Failure.init)
        .eraseToEffect()
    },
    createWorkout: { workout in
      Effect.future { callback in
        do {
          let _ = try Firestore
            .firestore()
            .collection("workouts")
            .addDocument(from: workout)
          callback(.success("Workout created successfully."))
        } catch {
          callback(.failure(.init(error)))
        }
      }
    },
    removeWorkout: { workouts in
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
