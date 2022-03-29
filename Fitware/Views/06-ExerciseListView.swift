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
          ForEachStore(store.scope(
            state: \.exercises,
            action: ExerciseListAction.exercises
          ), content: ExerciseNavigationLinkView.init(store:))
        }
#if os(iOS)
        .listStyle(.plain)
#endif
        .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
        .navigationTitle("Exercises")
        .onAppear { viewStore.send(.fetchExercises) }
        .searchable(text: viewStore.binding(\.$query.searchText))
        .overlay(ProgressView().opacity(viewStore.inFlight ? 1 : 0))
        .overlay(
          Text("No Results")
            .font(.title)
            .foregroundColor(.gray)
            .opacity(viewStore.exercises.isEmpty ? 0.5 : 0)
          )
        .toolbar {
          ToggleButton(toggle: viewStore.binding(\.$sheet)) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
          }
        }
        .sheet(isPresented: viewStore.binding(\.$sheet)) {
          NavigationView {
            List {
              Section("Search") {
                CustomPickerView("Bodypart",  BodyPart.allCases,      viewStore.binding(\.$query.bodyparts))
                CustomPickerView("Equipment", Equipment.allCases,     viewStore.binding(\.$query.equipment))
                CustomPickerView("Sex",       Sex.allCases,           viewStore.binding(\.$query.sex))
                CustomPickerView("Type",      ExerciseType.allCases,  viewStore.binding(\.$query.type))
                CustomPickerView("Primary",   Muscle.allCases,        viewStore.binding(\.$query.primary))
                CustomPickerView("Secondary", Muscle.allCases,        viewStore.binding(\.$query.secondary))
              }
            }
            .navigationTitle("Filter")
          }
        }
      }
    }
  }
}

struct ExerciseListView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseListView(store: ExerciseListState.defaultStore)
      .preferredColorScheme(.dark)
  }
}
