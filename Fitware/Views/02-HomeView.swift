import SwiftUI
import ComposableArchitecture
import User
import Today

struct HomeView: View {
  let store: Store<UserState, UserAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
#if os(iOS)
      TabView(selection: viewStore.binding(\.$route)) {
        NavigationView {
          TodayView(store: store.scope(state: \.today, action: UserAction.today))
        }
        .tag(Optional(UserState.Route.today))
        .tabItem { UserState.Route.today.label }
        
        NavigationView {
          WorkoutListView(store: store.scope(state: \.workoutList, action: UserAction.workoutList))
        }
        .tag(Optional(UserState.Route.workoutList))
        .tabItem { UserState.Route.workoutList.label }
        
        NavigationView {
          ExerciseListView(store: store.scope(state: \.exerciseList, action: UserAction.exerciseList))
        }
        .tag(Optional(UserState.Route.exerciseList))
        .tabItem { UserState.Route.exerciseList.label }
        
        NavigationView {
          SettingsView(store: store.scope(state: \.settings, action: UserAction.settings))
        }
        .tag(Optional(UserState.Route.settings))
        .tabItem { UserState.Route.settings.label }
      }
      
#elseif os(macOS)
      NavigationView {
        List(selection: viewStore.binding(\.$route)) {
          NavigationLink(
            destination: { TodayView(store: store.scope(state: \.today, action: UserAction.today)) },
            label: { UserState.Route.today.label }
          )
          .tag(UserState.Route.today)

          NavigationLink(
            destination: { WorkoutListView(store: store.scope(state: \.workoutList, action: UserAction.workoutList)) },
            label: { UserState.Route.workoutList.label }
          )
          .tag(UserState.Route.workoutList)

          NavigationLink(
            destination: { ExerciseListView(store: store.scope(state: \.exerciseList, action: UserAction.exerciseList)) },
            label: { UserState.Route.exerciseList.label }
          )
          .tag(UserState.Route.exerciseList)
          
          NavigationLink(
            destination: { SettingsView(store: store.scope(state: \.settings, action: UserAction.settings)) },
            label: { UserState.Route.settings.label }
          )
          .tag(UserState.Route.settings)
        }
        .listStyle(.sidebar)
        
        TodayView(store: store.scope(
          state: \.today,
          action: UserAction.today
        ))
        
        Text("No Selection")
          .font(.title)
          .foregroundColor(.gray)
          .opacity(0.5)
          .layoutPriority(0)
      }
#endif
    }
  }
}



private extension UserState.Route {
  var label: some View {
    switch self {
    case .today:
      return Label("Today", systemImage: "doc.text.image")
    case .exerciseList:
      return Label("Exercises", systemImage: "doc.plaintext")
    case .settings:
      return Label("Settings", systemImage: "gear")
    case .workoutList:
      return Label("Workouts", systemImage: "clock")
      
    }
  }
}


struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(store: UserState.defaultStore)
  }
}
