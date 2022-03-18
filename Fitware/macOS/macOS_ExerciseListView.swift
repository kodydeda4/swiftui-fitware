import SwiftUI
import ExerciseList
import ComposableArchitecture
import App

struct macOS_ExerciseListView: View {
  let store: Store<ExerciseListState, ExerciseListAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          ForEachStore(store.scope(
            state: \.searchResults,
            action: ExerciseListAction.exercises
          ), content: macOS_ExerciseView.init(store:))
        }
        .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
        .navigationTitle("Exercises")
        .onAppear { viewStore.send(.fetchExercises) }
        .searchable(text: viewStore.binding(\.$searchText))
      }
    }
  }
}

// MARK: SwiftUI Previews
struct macOS_ExerciseListView_Previews: PreviewProvider {
  static var previews: some View {
    macOS_ExerciseListView(store: ExerciseListState.defaultStore)
  }
}
