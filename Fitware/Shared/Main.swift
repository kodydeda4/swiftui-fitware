import SwiftUI
import App
import Firebase

@main
struct FitwareApp: App {
  init() {
    FirebaseApp.configure()
  }
  var body: some Scene {
    WindowGroup {
      AppView(store: AppState.defaultStore)
    }
  }
}
