import SwiftUI
import ComposableArchitecture
import Workout

struct WorkoutView: View {
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
          ), content: ExerciseNavigationLinkView.init(store:))
        }
      }
      .navigationTitle(viewStore.text)
    }
  }
}

struct WorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    WorkoutView(store: WorkoutState.defaultStore)
  }
}
