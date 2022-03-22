import App
import SwiftUI
import Firebase

@main
struct FitwareApp: App {
  init() {
    FirebaseApp.configure()
  }
  var body: some Scene {
    WindowGroup {
      #if os(iOS)
      iOS_AppView()
      #elseif os(macOS)
      macOS_AppView()
      #endif
    }
  }
}
