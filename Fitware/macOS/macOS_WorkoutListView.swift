import SwiftUI
import ExerciseList
import ComposableArchitecture
import App
import WorkoutList
import WorkoutListClient

struct macOS_WorkoutListView: View {
  let store: Store<WorkoutListState, WorkoutListAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          ForEach(viewStore.workouts) { workout in
            NavigationLink(workout.timestamp.description) {
              macOS_WorkoutDetailView(workout: workout)
            }
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

struct macOS_WorkoutDetailView: View {
  let workout: Workout
  
  var body: some View {
    VStack {
      Text("ID \(workout.id!)")
      Text("timestamp \(workout.timestamp.formatted())")
      Text("text \(workout.timestamp.formatted())")
      Text("done \(workout.done.description)")
      //      Text("exercises \(workout.exercises.count)")
    }
  }
}





// MARK: SwiftUI Previews
struct macOS_WorkoutListView_Previews: PreviewProvider {
  static var previews: some View {
    macOS_WorkoutListView(store: WorkoutListState.defaultStore)
  }
}
