import SwiftUI
import ComposableArchitecture
import User
import Today

struct HomeView: View {
  let store: Store<UserState, UserAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
#if os(iOS)
      TabView(
        selection: viewStore.binding(\.$route),
        content: { NavLinks(store: store) }
      )
#elseif os(macOS)
      NavigationView {
        List(
          selection: viewStore.binding(\.$route),
          content: { NavLinks(store: store) }
        )
        EmptyView()
        EmptyView()
      }
#endif
    }
  }
}

// MARK: - Private

private struct NavLinks: View {
  let store: Store<UserState, UserAction>
  
  var body: some View {
    Link(.today) {
      TodayView(store: store.scope(
        state: \.today,
        action: UserAction.today
      ))
    }
    Link(.workoutList)  {
      WorkoutListView(store: store.scope(
        state: \.workoutList,
        action: UserAction.workoutList
      ))
    }
    Link(.exerciseList) {
      ExerciseListView(store: store.scope(
        state: \.exerciseList,
        action: UserAction.exerciseList
      ))
    }
    Link(.settings) {
      SettingsView(store: store.scope(
        state: \.settings,
        action: UserAction.settings
      ))
    }
  }
  
  private func label(for route: UserState.Route) -> some View {
    switch route {
    case .today         : return Label("Today",     systemImage: "doc.text.image")
    case .exerciseList  : return Label("Exercises", systemImage: "doc.plaintext")
    case .settings      : return Label("Settings",  systemImage: "gear")
    case .workoutList   : return Label("Workouts",  systemImage: "clock")
    }
  }
  
  private func Link<Destination: View>(
    _ route: UserState.Route,
    @ViewBuilder destination: () -> Destination
  ) -> some View {
#if os(macOS)
    NavigationLink(
      destination: destination,
      label: { label(for: route) }
    )
    .tag(route)
#elseif os(iOS)
    NavigationView {
      destination()
    }
    .tag(Optional(route))
    .tabItem { label(for: route) }
#endif
  }
}

// MARK: SwiftUIPreviews
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(store: UserState.defaultStore)
  }
}

