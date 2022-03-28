import SwiftUI
import ComposableArchitecture
import Exercise
import AVKit

struct ExerciseNavigationLinkView: View {
  let store: Store<ExerciseState, ExerciseAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationLink(
        destination: destination,
        label: { label }
      )
    }
  }
  
  var destination: some View {
    WithViewStore(store) { viewStore in
      List {
        VideoPlayer(player: AVPlayer(url: viewStore.model.video))
          .aspectRatio(1920/1080, contentMode: .fit)

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
  
  var label: some View {
    WithViewStore(store) { viewStore in
      HStack {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .foregroundColor(.accentColor)
          .frame(width: 46, height: 46)
          .padding(.trailing, 2)
        
        VStack(alignment: .leading, spacing: 6) {
          Text(viewStore.model.name.capitalized)
          
          HStack {
            Text(viewStore.model.bodypart.map(\.rawValue.capitalized).joined(separator: ", "))
              .font(.caption)
            
            Text(viewStore.model.equipment.rawValue.capitalized)
              .font(.caption)
              .foregroundColor(.gray)
            
            Text(viewStore.model.type.rawValue.capitalized)
              .font(.caption)
              .foregroundColor(Color.gray.opacity(0.85))
          }
        }
      }
      .padding(.vertical, 4)
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
    ExerciseNavigationLinkView(store: ExerciseState.defaultStore)
      .destination
  }
}
