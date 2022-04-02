import ComposableArchitecture
import Combine
import Exercise
import Failure
import GymVisual

public struct ExerciseListClient {
  public let fetchExercises: () -> Effect<[ExerciseState], Failure>
  public let search: (
    _ state: IdentifiedArrayOf<ExerciseState>,
    _ query: ExerciseListQuery
  ) -> Effect<[ExerciseState], Never>
}

public extension ExerciseListClient {
  static let live = Self(
    fetchExercises: {
      Effect(value: Exercise.allCases.map(ExerciseState.init))
    },
    search: { state, query in
      Effect(value: state
        .filter({ query.bodyparts.isSuperset(of: Set($0.bodyparts)) })
        .filter({ query.equipment.contains($0.equipment) })
        .filter({ query.sex.contains($0.sex) })
        .filter({ query.type.contains($0.type) })
        .filter({ query.primary.isSuperset(of: Set($0.primaryMuscles)) })
        .filter({ query.secondary.isSuperset(of: Set($0.secondaryMuscles)) })
      )
    }
  )
}

private let url = Bundle.main.url(forResource: "ExercisesJSON", withExtension: nil)!
