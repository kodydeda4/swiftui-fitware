import SwiftUI
import ComposableArchitecture
import Exercise

#if os(iOS)
import VideoPlayer
#endif

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
        #if os(iOS)
        VideoPlayer(url: viewStore.model.video, play: .constant(true))
          .autoReplay(true)
          .aspectRatio(1920/1080, contentMode: .fit)
        #endif
        
        Section("Details") {
          prompt("ID", "\(viewStore.id)")
          prompt("Name", viewStore.model.name)
          prompt("Type", viewStore.model.type.rawValue)
          prompt("Equipment", viewStore.model.equipment.rawValue)
          prompt("Sex", viewStore.model.sex.rawValue)
        }
        
        Section("Body Parts") {
          ForEach(viewStore.model.bodyparts, id: \.self) {
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
      #if os(iOS)
      .navigationBarTitleDisplayMode(.inline)
      #endif
    }
  }
  
  var label: some View {
    WithViewStore(store) { viewStore in
      HStack {
        AsyncImage(
          url: viewStore.model.photo,
          content: { $0.resizable().scaledToFill() },
          placeholder: ProgressView.init
        )
        .frame(width: 46, height: 46)
        .background(GroupBox { Color.clear })
        .clipShape(
          RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .strokeBorder(lineWidth: 1, antialiased: true)
            .foregroundColor(
              .gray
            )
        )
        
        VStack(alignment: .leading, spacing: 6) {
          Text(viewStore.model.name.capitalized)
          
          HStack {
            Text(viewStore.model.bodyparts.map(\.rawValue.capitalized).joined(separator: ", "))
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

    ExerciseNavigationLinkView(store: ExerciseState.defaultStore)
      .label
  }
}
