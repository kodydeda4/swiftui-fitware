import SwiftUI
import ExerciseList
import ComposableArchitecture
import App
import User

struct macOS_UserView: View {
  let store: Store<UserState, UserAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          NavigationLink(
            tag: UserState.Route.exerciseList,
            selection: viewStore.binding(\.$route),
            destination: {
              macOS_ExerciseListView(store: store.scope(
                state: \.exerciseList,
                action: UserAction.exerciseList
              ))
            },
            label: { Label("Exercises", systemImage: "doc.plaintext") }
          )
        }
        .listStyle(.sidebar)
      }
    }
  }
}

// MARK: SwiftUI Previews
struct macOS_UserView_Previews: PreviewProvider {
  static var previews: some View {
    macOS_UserView(store: UserState.defaultStore)
  }
}
