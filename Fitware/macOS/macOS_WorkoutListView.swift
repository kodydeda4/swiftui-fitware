import SwiftUI
import ExerciseList
import ComposableArchitecture
import App
import WorkoutList

struct macOS_WorkoutListView: View {
  let store: Store<WorkoutListState, WorkoutListAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          ForEach(viewStore.workouts) { workout in
            Text(workout.timestamp.formatted())
          }
        }
        .navigationTitle("Workouts \(viewStore.workouts.count.description)")
        .onAppear { viewStore.send(.fetchWorkouts) }
        .refreshable { viewStore.send(.fetchWorkouts) }
        //        .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
        .toolbar {
          ToolbarItemGroup {
            Button("Create Workout") {
              viewStore.send(.createWorkout)
            }
          }
        }
      }
    }
  }
}

// MARK: SwiftUI Previews
struct macOS_WorkoutListView_Previews: PreviewProvider {
  static var previews: some View {
    macOS_WorkoutListView(store: WorkoutListState.defaultStore)
  }
}
