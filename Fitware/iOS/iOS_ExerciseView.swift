import SwiftUI
import Exercise
import ComposableArchitecture

struct iOS_ExerciseView: View {
  let store: Store<ExerciseState, ExerciseAction>
  let url = "https://www.id-design.com/videos/21021201-Sitting-Toe-Pull-Calf-Stretch_Calves_.mp4"
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationLink(viewStore.name) {
        List {
          //          VideoPlayer(player: AVPlayer(url: URL(string: url)!))
          //            .aspectRatio(1920/1080, contentMode: .fit)
          Section("Details") {
            prompt("ID", "\(viewStore.id)")
            prompt("Name", viewStore.name)
            prompt("Type", viewStore.type)
            prompt("Bodypart", viewStore.bodypart)
            prompt("Equipment", viewStore.equipment)
            prompt("Gender", viewStore.gender)
            prompt("Target", viewStore.target)
            prompt("Synergist", viewStore.synergist)
          }
        }
        .lineLimit(1)
      }
    }
  }
  
  private func prompt(_ title: String, _ subtitle: String) -> some View {
    HStack {
      Text(title).bold()
      Text(subtitle)
    }
  }
}

// MARK: SwiftUI Previews
struct iOS_ExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    iOS_ExerciseView(store: ExerciseState.defaultStore)
  }
}
