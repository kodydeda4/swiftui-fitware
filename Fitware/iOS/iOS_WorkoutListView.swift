import SwiftUI
import ExerciseList
import ComposableArchitecture
import App
import Workout
import WorkoutList
import WorkoutListClient

struct iOS_WorkoutListView: View {
  let store: Store<WorkoutListState, WorkoutListAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          ForEachStore(
            store.scope(
              state: \.workouts,
              action: WorkoutListAction.workouts
            ), content: iOS_WorkoutNavigationLinkView.init(store:)
          )
        }
        .navigationTitle("Workouts \(viewStore.workouts.count.description)")
        .onAppear { viewStore.send(.fetchWorkouts) }
        .refreshable { viewStore.send(.fetchWorkouts) }
        .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
        .toolbar {
          ToolbarItemGroup {
            Button("Create Workout") {
              viewStore.send(.createWorkout)
            }
//            Button("Clear All") {
//              viewStore.send(.clearAll)
//            }
          }
        }
      }
    }
  }
}

struct iOS_WorkoutNavigationLinkView: View {
  let store: Store<WorkoutState, WorkoutAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationLink(destination: iOS_WorkoutView(store: store)) {
        Text(viewStore.text)
      }
      .swipeActions(edge: .trailing) {
        Button(role: .destructive, action: { viewStore.send(.deleteButtonTapped) }) {
          Label("Delete", systemImage: "trash")
        }
      }
    }
  }
}

// MARK: SwiftUI Previews
struct iOS_WorkoutListView_Previews: PreviewProvider {
  static var previews: some View {
    iOS_WorkoutListView(store: WorkoutListState.defaultStore)
  }
}
