import SwiftUI
import ExerciseList
import ComposableArchitecture
import App
import User

struct iOS_UserView: View {
  let store: Store<UserState, UserAction>

  var body: some View {
    TabView {
      iOS_ExerciseListView(store: store.scope(
        state: \.exerciseList,
        action: UserAction.exerciseList
      ))
        .tabItem { Label("Exercises", systemImage: "doc.plaintext") }
      
      Text("Not Implemented").tabItem { Label("Settings", systemImage: "gear") }
    }
  }
}

// MARK: SwiftUI Previews
struct iOS_UserView_Previews: PreviewProvider {
  static var previews: some View {
    iOS_UserView(store: UserState.defaultStore)
  }
}
