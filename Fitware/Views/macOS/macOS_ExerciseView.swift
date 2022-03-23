import SwiftUI
import Exercise
import ComposableArchitecture

struct macOS_ExerciseView: View {
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
          }
          
          Section("Primary") {
            ForEach(viewStore.primaryMuscles, id: \.self) {
              Text($0)
            }
          }
          Section("Secondary") {
            ForEach(viewStore.secondaryMuscles, id: \.self) {
              Text($0)
            }
          }
        }
        .lineLimit(1)
        .navigationTitle(viewStore.name)
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
struct macOS_ExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    macOS_ExerciseView(store: ExerciseState.defaultStore)
  }
}
