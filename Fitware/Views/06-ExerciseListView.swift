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
        .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
        .navigationTitle("Exercises")
        .onAppear { viewStore.send(.fetchExercises) }
        .searchable(
          text: viewStore.binding(\.$searchText)
//          ,
//          placement: .navigationBarDrawer(displayMode: .always)
        )
      }
    }
  }
}

struct ExerciseListView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseListView(store: ExerciseListState.defaultStore)
      .previewDevice(.iPhone13ProMax)
    
    ExerciseListView(store: ExerciseListState.defaultStore)
      .previewDevice(.mac)

  }
}

extension PreviewDevice {
  static let iPhone13ProMax = PreviewDevice(rawValue: "iPhone 13 Pro Max")
  static let mac = PreviewDevice(rawValue: "mac")
}
