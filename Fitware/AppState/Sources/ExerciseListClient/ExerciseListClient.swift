import ComposableArchitecture
import Combine
import Exercise
import Failure

public struct ExerciseListClient {
  public let loadJSON: () -> Effect<[ExerciseState], Failure>
  public let saveJSON: ([ExerciseState]) -> Effect<Never, Failure>
}

public extension ExerciseListClient {
  static let live = Self(
    loadJSON: {
      Effect.future { callback in
        do {
          let rv = try JSONDecoder().decode([ExerciseState].self, from: Data(contentsOf: url))
          return callback(.success(rv))
        }
        catch {
          return callback(.failure(Failure("Failed to load")))
        }
      }
    },
    saveJSON: { models in
      Effect.future { callback in
        do {
          try JSONEncoder().encode(models).write(to: url)
        }
        catch {
          return callback(.failure(Failure("Failed to save")))
        }
      }
    }
  )
}

private let url = Bundle.main.url(forResource: "ExerciseList", withExtension: nil)!
