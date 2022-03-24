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
            .decode([Exercise].self, from: Data(contentsOf: url))
            .map(ExerciseState.init)
            
          return callback(.success(rv))
        }
        catch {
          return callback(.failure(Failure(error.localizedDescription)))
        }
      }
    }
  )
}

private let url = Bundle.main.url(forResource: "ExercisesJSON", withExtension: nil)!
