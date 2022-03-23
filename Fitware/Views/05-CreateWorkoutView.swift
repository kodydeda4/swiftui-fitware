import SwiftUI
import ComposableArchitecture
import CreateWorkout
import Exercise

struct CreateWorkoutView: View {
  let store: Store<CreateWorkoutState, CreateWorkoutAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      List {
        Section("Details") {
          HStack {
            Text("Name:")
              .bold()
            TextField("Name", text: viewStore.binding(\.$name))
          }
        }
        Section("Exercises") {
          ForEachStore(store.scope(
            state: \.exercises,
            action: CreateWorkoutAction.exercises
          ),content: CellView.init(store:))
        }
      }
      .buttonStyle(.plain)
      .navigationTitle("Create Workout")
      .onAppear { viewStore.send(.fetchExercises) }
      .toolbar {
        Button("Done") {
          viewStore.send(.createWorkout)
        }
        .foregroundColor(.blue)
      }
#if os(macOS)
      .frame(width: 500, height: 500)
#endif
    }
  }
}


private struct CellView: View {
  let store: Store<ExerciseState, ExerciseAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ToggleButton(toggle: viewStore.binding(\.$selected)) {
        HStack {
          Image(systemName: viewStore.selected ? "minus" : "plus")
            .frame(width: 20, height: 20)
            .background(viewStore.selected ? Color.red : Color.green)
            .foregroundColor(.white)
            .clipShape(Circle())
          
          Text(viewStore.name)
        }
      }
      .opacity(viewStore.selected ? 1 : 0.5)
    }
  }
}

struct CreateWorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    MultiDevicePreview {
      CreateWorkoutView(store: CreateWorkoutState.defaultStore)
    }
  }
}

