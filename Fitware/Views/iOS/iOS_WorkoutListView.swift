import SwiftUI
import ExerciseList
import ComposableArchitecture
import App
import Workout
import WorkoutList
import WorkoutListClient
import Exercise

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
        .navigationTitle("Workouts")
        .onAppear { viewStore.send(.fetchWorkouts) }
        .refreshable { viewStore.send(.fetchWorkouts) }
        .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
        .toolbar {
          ToolbarItemGroup {
            Button("Create") {
              viewStore.send(.createWorkoutButtonTapped)
            }
//            Button("Clear All") {
//              viewStore.send(.clearAll)
//            }
          }
        }
        .sheet(isPresented: viewStore.binding(
          get: { $0.createWorkout != nil },
          send: WorkoutListAction.createWorkoutButtonTapped
        )) {
          IfLetStore(store.scope(
            state: \.createWorkout,
            action: WorkoutListAction.createWorkout
          ), then: iOS_CreateWorkoutView.init(store:))
        }
        .overlay(
          Text("No Results")
            .font(.title)
            .foregroundColor(.gray)
            .opacity(0.5)
            .opacity(viewStore.workouts.isEmpty ? 1 : 0)
        )
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

private struct iOS_ExerciseCellView: View {
  let store: Store<ExerciseState, ExerciseAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      Text(viewStore.name)
        .lineLimit(1)
    }
  }
}

// MARK: SwiftUI Previews
struct iOS_WorkoutListView_Previews: PreviewProvider {
  static var previews: some View {
    iOS_WorkoutListView(store: WorkoutListState.defaultStore)
  }
}
