import SwiftUI
import ExerciseList
import ComposableArchitecture
import App

struct ExerciseListView: View {
  let store: Store<ExerciseListState, ExerciseListAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          ForEachStore(store.scope(
            state: \.searchResults,
            action: ExerciseListAction.exercises
          ), content: ExerciseView.init(store:))
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
struct ExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseListView(store: ExerciseListState.defaultStore)
      .preferredColorScheme(.dark)
  }
}
