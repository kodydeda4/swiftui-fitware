import SwiftUI
import ComposableArchitecture
import User

struct UserView: View {
  let store: Store<UserState, UserAction>
  
  var body: some View {
    TabView {
      ExerciseListView(store: store.scope(
        state: \.exerciseList,
        action: UserAction.exerciseList
      ))
        .tabItem { Label("Exercises", systemImage: "doc.plaintext") }
      
      Text("Not Implemented").tabItem { Label("Settings", systemImage: "gear") }
    }
  }
}

struct UserView_Previews: PreviewProvider {
  static var previews: some View {
    UserView(store: UserState.defaultStore)
  }
}
