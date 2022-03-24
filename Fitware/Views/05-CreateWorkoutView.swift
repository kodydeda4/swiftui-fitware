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
        ToolbarItemGroup {
          Button("Done") {
            viewStore.send(.createWorkout)
          }
          .foregroundColor(.blue)
        }
      }
#if os(iOS)
      .navigationView()
#elseif os(macOS)
      .frame(width: 500, height: 500)
#endif
    }
  }
}

private extension View {
  func navigationView() -> some View {
    NavigationView {
      self
    }
  }
}


private struct CellView: View {
  let store: Store<ExerciseState, ExerciseAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ToggleButton(toggle: viewStore.binding(\.$selected)) {
        HStack {
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundColor(.accentColor)
            .frame(width: 34, height: 34)
          
          VStack(alignment: .leading) {
            Text(viewStore.model.name)
            Text(viewStore.model.bodypart.map(\.rawValue).joined(separator: ", "))
              .foregroundColor(.gray)
          }

          Spacer()
          
          Image(systemName: viewStore.selected ? "minus" : "plus")
            .frame(width: 20, height: 20)
            .background(viewStore.selected ? Color.red : Color.green)
            .foregroundColor(.white)
            .clipShape(Circle())
        }
      }
      .opacity(viewStore.selected ? 1 : 0.5)
    }
  }
}




struct CreateWorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    CreateWorkoutView(store: CreateWorkoutState.defaultStore)
  }
}
