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
          ), content: CellView.init)
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
          AsyncImage(
            url: viewStore.model.photo,
            content: { $0.resizable().scaledToFill() },
            placeholder: ProgressView.init
          )
          .frame(width: 46, height: 46)
          .background(GroupBox { Color.clear })
          .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
          .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
              .strokeBorder(lineWidth: 1, antialiased: true)
              .foregroundColor(.gray)
          )
          VStack(alignment: .leading, spacing: 6) {
            Text(viewStore.model.name.capitalized)
              .foregroundColor(viewStore.selected ? .accentColor : .primary)
            
            HStack {
              Text(viewStore.model.bodyparts.map(\.rawValue.capitalized).joined(separator: ", "))
                .font(.caption)
              
              Text(viewStore.model.equipment.rawValue.capitalized)
                .font(.caption)
                .foregroundColor(.gray)
              
              Text(viewStore.model.type.rawValue.capitalized)
                .font(.caption)
                .foregroundColor(Color.gray.opacity(0.85))
            }
          }
        }
      }
      .padding(.vertical, 4)
    }
  }
}




struct CreateWorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    CreateWorkoutView(store: CreateWorkoutState.defaultStore)
    
    CellView(store: ExerciseState.defaultStore)
  }
}
