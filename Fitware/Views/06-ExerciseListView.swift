import SwiftUI
import ExerciseList
import ComposableArchitecture
import App
import Exercise

struct ExerciseListView: View {
  let store: Store<ExerciseListState, ExerciseListAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          Section("Search") {
            CustomPickerView("Bodypart",  BodyPart.allCases,      viewStore.binding(\.$bodyparts))
            CustomPickerView("Equipment", Equipment.allCases,     viewStore.binding(\.$equipment))
            CustomPickerView("Sex",       Sex.allCases,           viewStore.binding(\.$sex))
            CustomPickerView("Type",      ExerciseType.allCases,  viewStore.binding(\.$type))
//            CustomPickerView("Primary",   Muscle.allCases,        viewStore.binding(\.$primary))
//            CustomPickerView("Secondary", Muscle.allCases,        viewStore.binding(\.$secondary))
          }
          Section(header: HStack {
            Text("Results")
            Spacer()
            Text("\(viewStore.searchResults.count) / \(viewStore.exercises.count)")
          }) {
            ForEachStore(store.scope(
              state: \.searchResults,
              action: ExerciseListAction.exercises
            ), content: ExerciseNavigationLinkView.init(store:))
          }
        }
        .listStyle(.plain)
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
  }
}
