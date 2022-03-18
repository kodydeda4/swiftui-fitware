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
          let rv = try JSONDecoder().decode([ExerciseState].self, from: Data(contentsOf: url))
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
