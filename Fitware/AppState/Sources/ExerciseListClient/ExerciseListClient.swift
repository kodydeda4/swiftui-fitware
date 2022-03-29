import ComposableArchitecture
import Combine
import Exercise
import Failure

public struct ExerciseListClient {
  public let fetchExercises: () -> Effect<[Exercise], Failure>
  public let search: (_ state: IdentifiedArrayOf<ExerciseState>, _ query: ExerciseListQuery) -> Effect<[ExerciseState], Never>
}

public extension ExerciseListClient {
  static let live = Self(
    fetchExercises: {
      Effect.future { callback in
        do {
          let rv = try JSONDecoder()
            .decode([Exercise].self, from: Data(contentsOf: url))
            
          return callback(.success(rv))
        }
        catch {
          return callback(.failure(Failure(error.localizedDescription)))
        }
      }
    },
    search: { state, query in
//      Effect(value: [])
      Effect(value: state
        .filter({ query.bodyparts.isSuperset(of: Set($0.model.bodyparts)) })
        .filter({ query.equipment.contains($0.model.equipment) })
        .filter({ query.sex.contains($0.model.sex) })
        .filter({ query.type.contains($0.model.type) })
        .filter({ query.primary.isSuperset(of: Set($0.model.primaryMuscles)) })
        .filter({ query.secondary.isSuperset(of: Set($0.model.secondaryMuscles)) })
      )
    }
  )
}

private let url = Bundle.main.url(forResource: "ExercisesJSON", withExtension: nil)!
