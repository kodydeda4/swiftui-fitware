import SwiftUI
import ComposableArchitecture
import CreateWorkout
import Exercise

struct iOS_CreateWorkoutView: View {
  let store: Store<CreateWorkoutState, CreateWorkoutAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          Section {
            TextField("Name", text: viewStore.binding(\.$name))
          }
          Section {
            Button("Create") {
              viewStore.send(.createWorkout)
            }
            .foregroundColor(.blue)
          }

          Section("Exercises") {
            ForEachStore(store.scope(
              state: \.exercises,
              action: CreateWorkoutAction.exercises
            )) { childStore in
              WithViewStore(childStore) { childViewStore in
                CellView(store: childStore)
                  .opacity(
                    viewStore.selection.contains(childViewStore.state) ? 1 : 0.5
                  )
              }
            }
          }
        }
        .buttonStyle(.plain)
        .navigationTitle("Create Workout")
        .onAppear {
          viewStore.send(.fetchExercises)
        }
      }
    }
  }
}


private struct CellView: View {
  let store: Store<ExerciseState, ExerciseAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack {
        Button(action: {
          viewStore.send(.addButtonTapped)
        }) {
          Image(systemName: "plus")
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(Circle())
        }
        Text(viewStore.name)
      }
    }
  }
}

struct iOS_CreateWorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    iOS_CreateWorkoutView(store: CreateWorkoutState.defaultStore)
  }
}
