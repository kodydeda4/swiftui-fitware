import SwiftUI
import ExerciseList
import ComposableArchitecture
import App
import WorkoutList

struct iOS_WorkoutListView: View {
  let store: Store<WorkoutListState, WorkoutListAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          Text("Workouts")
//          ForEachStore(store.scope(
//            state: \.exercises,
//            action: WorkoutAction.exercises
//          ), content: iOS_ExerciseView.init(store:))
        }
        .navigationTitle("Workouts")
        .onAppear { viewStore.send(.load) }
        .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
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

//// MARK: SwiftUI Previews
//struct iOS_ExerciseListView_Previews: PreviewProvider {
//  static var previews: some View {
//    iOS_ExerciseListView(store: ExerciseListState.defaultStore)
//  }
//}
