import SwiftUI
import ComposableArchitecture
import Settings

struct iOS_SettingsView: View {
  let store: Store<SettingsState, SettingsAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          VStack(alignment: .center) {
            Avatar(url: viewStore.user.photoURL)
            
            Text(viewStore.user.displayName ?? "Guest")
              .font(.title2)
            
            Text(viewStore.user.email ?? "email@example.com")
              .font(.caption)
              .foregroundColor(.gray)
          }
          .frame(maxWidth: .infinity, alignment: .center)
          .listRowSeparator(.hidden)
          .listRowBackground(Color.clear)
          
          Section {
            Button("Sign out") {
              viewStore.send(.signoutButtonTapped)
            }
            .foregroundColor(.red)
          }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
      }
    }
  }
}

struct Avatar: View {
  let url: URL?
  var body: some View {
    AsyncImage(
      url: url ?? URL(string: "https://www.google.com")!,
      transaction: Transaction(animation: .spring())
    ) { phase in
      switch phase {
        
      case .empty:
        ProgressView()
        
      case let .success(image):
        image
          .resizable()
          .scaledToFill()
        
      case .failure:
        Image(systemName: "person.crop.circle.fill")
          .resizable()
          .scaledToFit()
          .foregroundColor(.gray)
        
      @unknown default:
        Image(systemName: "exclamationmark.icloud")
          .resizable()
          .scaledToFit()
      }
    }
    .frame(width: 75, height: 75)
    .background(GroupBox { Color.clear })
    .clipShape(Circle())

  }
}

struct iOS_SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    iOS_SettingsView(store: SettingsState.defaultStore)
  }
}
