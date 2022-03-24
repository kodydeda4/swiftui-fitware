import SwiftUI
import ComposableArchitecture
import Exercise

struct ExerciseView: View {
  let store: Store<ExerciseState, ExerciseAction>
  let url = "https://www.id-design.com/videos/21021201-Sitting-Toe-Pull-Calf-Stretch_Calves_.mp4"
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationLink(viewStore.model.name) {
        List {
          //          VideoPlayer(player: AVPlayer(url: URL(string: url)!))
          //            .aspectRatio(1920/1080, contentMode: .fit)
          Section("Details") {
            prompt("ID", "\(viewStore.id)")
            prompt("Name", viewStore.model.name)
            prompt("Type", viewStore.model.type.rawValue)
            prompt("Equipment", viewStore.model.equipment.rawValue)
            prompt("Sex", viewStore.model.sex.rawValue)
          }
          
          Section("Body Parts") {
            ForEach(viewStore.model.bodypart, id: \.self) {
              Text($0.rawValue)
            }
          }
          Section("Primary") {
            ForEach(viewStore.model.primaryMuscles, id: \.self) {
              Text($0.rawValue)
            }
          }
          Section("Secondary") {
            ForEach(viewStore.model.secondaryMuscles, id: \.self) {
              Text($0.rawValue)
            }
          }
        }
        .lineLimit(1)
        .navigationTitle(viewStore.model.name)
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

struct ExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseView(store: ExerciseState.defaultStore)
  }
}
