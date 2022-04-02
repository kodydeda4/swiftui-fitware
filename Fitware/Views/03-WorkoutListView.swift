import SwiftUI
import ExerciseList
import ComposableArchitecture
import App
import Workout
import WorkoutList

struct WorkoutListView: View {
  let store: Store<WorkoutListState, WorkoutListAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      List {
        ForEachStore(
          store.scope(
            state: \.workouts,
            action: WorkoutListAction.workouts
          ), content: WorkoutNavigationLinkView.init(store:)
        )
      }
      .navigationTitle("Workouts")
      .onAppear { viewStore.send(.fetchWorkouts) }
      .refreshable { viewStore.send(.fetchWorkouts) }
      .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
      .toolbar {
        Menu(content: {
          Button(action: {
            viewStore.send(.createWorkoutButtonTapped)
          }) {
            Label("Create New", systemImage: "plus")
          }
          Button(
            role: .destructive,
            action: { viewStore.send(.clearAll) }
          ) {
            Label("Clear All", systemImage: "trash")
          }
        }) {
          Label("Menu", systemImage: "ellipsis.circle")
        }
      }
      .sheet(isPresented: viewStore.binding(
        get: { $0.createWorkout != nil },
        send: WorkoutListAction.createWorkoutButtonTapped
      )) {
        IfLetStore(store.scope(
          state: \.createWorkout,
          action: WorkoutListAction.createWorkout
        ), then: CreateWorkoutView.init(store:))
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

struct WorkoutNavigationLinkView: View {
  let store: Store<WorkoutState, WorkoutAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationLink(destination: WorkoutView(store: store)) {
        Text(viewStore.text)
          .lineLimit(1)
      }
      .swipeActions(edge: .trailing) {
        Button(role: .destructive, action: { viewStore.send(.deleteButtonTapped) }) {
          Label("Delete", systemImage: "trash")
        }
      }
    }
  }
}

struct WorkoutListView_Previews: PreviewProvider {
  static var previews: some View {
    WorkoutListView(store: WorkoutListState.defaultStore)
  }
}
