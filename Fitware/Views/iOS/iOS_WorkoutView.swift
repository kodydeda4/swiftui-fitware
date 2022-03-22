import SwiftUI
import Workout
import ComposableArchitecture

struct iOS_WorkoutView: View {
  let store: Store<WorkoutState, WorkoutAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      List {
        Section("About") {
          Text("ID \(viewStore.id!)")
          Text("timestamp \(viewStore.timestamp.formatted())")
          Text("text \(viewStore.timestamp.formatted())")
          Text("done \(viewStore.done.description)")
        }
        Section("Exercises") {
          ForEachStore(store.scope(
            state: \.exercises,
            action: WorkoutAction.exercises
          ), content: iOS_ExerciseView.init(store:))
        }
      }
      .navigationTitle(viewStore.text)
    }
  }
}

//struct iOS_WorkoutView_Previews: PreviewProvider {
//  static var previews: some View {
//    iOS_WorkoutView(store: WorkoutState.defaultStore)
//  }
//}
