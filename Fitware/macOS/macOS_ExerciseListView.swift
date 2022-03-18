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
        .navigationTitle("Exercises")
        .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
        .onAppear { viewStore.send(.load) }
        .searchable(
          text: viewStore.binding(\.$searchText)//,
          //          placement: .navigationBarDrawer(displayMode: .always)
        )
        .toolbar {
          ToolbarItemGroup {
            Button("Save") {
              viewStore.send(.save)
            }
          }
        }
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
