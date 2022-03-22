import ComposableArchitecture
import Combine
import Exercise
import Failure

public struct ExerciseListClient {
  public let fetchExercises: () -> Effect<[ExerciseState], Failure>
}

public extension ExerciseListClient {
  static let live = Self(
    fetchExercises: {
      Effect.future { callback in
        do {
          let rv = try JSONDecoder()
            .decode([ExerciseModel].self, from: Data(contentsOf: url))
            .map {
              ExerciseState.init(
                id: $0.id,
                name: $0.name,
                type: $0.type,
                bodypart: $0.bodypart,
                equipment: $0.equipment,
                gender: $0.gender,
                primaryMuscles: Array($0.target.components(separatedBy: ", ")),
                secondaryMuscles: Array($0.synergist.components(separatedBy: ", "))
              )
            }
          
          return callback(.success(rv))
        }
        catch {
          return callback(.failure(Failure("Failed to load")))
        }
      }
    }
  )
}

private let url = Bundle.main.url(forResource: "ExerciseList", withExtension: nil)!
