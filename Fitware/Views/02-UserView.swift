import SwiftUI
import ComposableArchitecture
import User

struct UserView: View {
  let store: Store<UserState, UserAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
#if os(iOS)
      TabView {
        WorkoutListView(store: store.scope(
          state: \.workoutList,
          action: UserAction.workoutList
        ))
        .tabItem { UserState.Route.workoutList.label }
        
        ExerciseListView(store: store.scope(
          state: \.exerciseList,
          action: UserAction.exerciseList
        ))
        .tabItem { UserState.Route.exerciseList.label }
        
        SettingsView(store: store.scope(
          state: \.settings,
          action: UserAction.settings
        ))
        .tabItem { UserState.Route.settings.label }
      }
      
#elseif os(macOS)
      NavigationView {
        List {
          NavigationLink(
            tag: UserState.Route.workoutList,
            selection: viewStore.binding(\.$route),
            destination: {
              WorkoutListView(store: store.scope(
                state: \.workoutList,
                action: UserAction.workoutList
              ))
            },
            label: { UserState.Route.workoutList.label }
          )
          NavigationLink(
            tag: UserState.Route.exerciseList,
            selection: viewStore.binding(\.$route),
            destination: {
              ExerciseListView(store: store.scope(
                state: \.exerciseList,
                action: UserAction.exerciseList
              ))
            },
            label: { UserState.Route.exerciseList.label }
          )
          NavigationLink(
            tag: UserState.Route.settings,
            selection: viewStore.binding(\.$route),
            destination: {
              SettingsView(store: store.scope(
                state: \.settings,
                action: UserAction.settings
              ))
            },
            label: { UserState.Route.settings.label }
          )
          
        }
        .listStyle(.sidebar)
      }
      #endif
    }
  }
}


private extension UserState.Route {
  var label: some View {
    switch self {
    case .exerciseList:
      return Label("Exercises", systemImage: "doc.plaintext")
    case .settings:
      return Label("Settings", systemImage: "gear")
    case .workoutList:
      return Label("Workouts", systemImage: "doc.text.image")
    }
  }
}


struct UserView_Previews: PreviewProvider {
  static var previews: some View {
    UserView(store: UserState.defaultStore)
  }
}
