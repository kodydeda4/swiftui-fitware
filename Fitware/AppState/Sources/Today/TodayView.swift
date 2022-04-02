import SwiftUI
import GymVisual
import ComposableArchitecture
import Exercise
import AVKit

public func TodayView(store: Store<TodayState, TodayAction>) -> some View {
  WithViewStore(store) { viewStore in
    NavigationView {
      List {
        Section {
          VStack(alignment: .leading, spacing: 8) {
            Text("push 2".capitalized)
              .font(.subheadline)
              .foregroundColor(.accentColor)
            
            Text(viewStore.exerciseDescription)
              .font(.headline)
              .setListRowSeparator(.hidden)
            
            ProgressView(
              value: Double(viewStore.exercises.filter(\.complete).count),
              total: Double(viewStore.exercises.count)
            )
            
            Text("John's Push Pull Split")
              .foregroundStyle(.secondary)
          }
        }
        .listRowBackground(EmptyView())
        .setListRowSeparator(.hidden, edges: .bottom)
        
        ForEachStore(store.scope(
          state: \.exercises,
          action: TodayAction.exercises
        ), content: ExerciseView)
      }
      .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
      .navigationTitle("Today")
      .listStyle(.inset)
//      .setNavigationBarTitleDisplayMode(.large)
      .toolbar {
        Menu(
          content: {
            Button(action: {
              viewStore.send(.submitButtonTapped)
            }) {
              Label("Finish Workout", systemImage: "checkmark.square.fill")
            }
          },
          label: {
            Label("Menu", systemImage: "ellipsis")
          }
        )
      }
    }
  }
}

private func ExerciseView(_ store: Store<ExerciseState, ExerciseAction>) -> some View {
  WithViewStore(store) { viewStore in
    NavigationLink(destination: ExerciseDetailView(store)) {
      HStack {
        Image(systemName: "checkmark.circle")
          .foregroundColor(viewStore.complete ? .accentColor : .secondary)
        
        AsyncIcon(viewStore.photo)
        
        VStack(alignment: .leading, spacing: 6) {
          Text(viewStore.name.capitalized)
            .bold()
          
          Text(viewStore.bodyparts.map(\.rawValue.capitalized).joined(separator: ", "))
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
      }
      .padding(.vertical, 4)
      .lineLimit(1)
    }
  }
}

// MARK: - Views...
private func ExerciseDetailView(_ store: Store<ExerciseState, ExerciseAction>) -> some View {
  WithViewStore(store) { viewStore in
    List {
      HStack {
        Video(viewStore.video)
        
        VStack(alignment: .leading) {
          Text(viewStore.name)
            .font(.title)
            .fontWeight(.semibold)
          
          Text(viewStore.bodyparts.map(\.rawValue).joined(separator: ", "))
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.accentColor)
          
          Text(viewStore.type.rawValue.uppercased())
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
          
          Text(viewStore.equipment.rawValue)
            .font(.subheadline)
            .foregroundColor(.secondary)
          
          VStack(alignment: .leading) {
            Text(viewStore.primaryMuscles.map(\.rawValue).joined(separator: ", "))
            Text(viewStore.secondaryMuscles.map(\.rawValue).joined(separator: ", "))
          }
          .padding(.top)
          .font(.subheadline)
          .foregroundColor(.secondary)
        }
        .padding(.leading)
        
        Spacer()
      }
      .listRowBackground(EmptyView())
      .setListRowSeparator(.hidden)
      .padding(.bottom, 32)
      
      Section(
        content: { ExerciseSetGridView(store) },
        header: {},
        footer: {
          Button(action: {
            viewStore.send(.addSet)
          }) {
            Label("Add Set", systemImage: "plus.circle.fill")
          }
          .buttonStyle(.plain)
          .foregroundColor(.accentColor)
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.trailing)
          .setListRowSeparator(.hidden, edges: .bottom)
        }
      )
    }
    .lineLimit(1)
//    .setNavigationBarTitleDisplayMode(.inline)
    .listStyle(.inset)
    .toolbar {
      ToolbarItemGroup {
        HStack {
          Button(action: {}) {
            Label("History", systemImage: "clock")
          }
          ToggleButton(value: viewStore.binding(\.$favorite)) {
            Label("Favorite", systemImage: viewStore.favorite ? "heart.fill" : "heart")
          }
        }
      }
    }
  }
}



private func ExerciseSetGridView(_ store: Store<ExerciseState, ExerciseAction>) -> some View {
  WithViewStore(store) { viewStore in
    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
      Text("Set")
      Text("Previous")
      Text("Weight")
      Text("Reps")
      Text("Done")
    }.foregroundStyle(.secondary)
    
    ForEach(Array(zip(
      viewStore.binding(\.$exerciseSets),
      viewStore.exerciseSets.indices)
    ), id: \.1) { $exerciseSet, index in
      
      LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
        Text("\(index+1)")
        
        Text(exerciseSet.previousDescription)
          .foregroundColor(exerciseSet.previousDescriptionColor)
        
        TextField(
          exerciseSet.weight.description,
          value: $exerciseSet.weight,
          formatter: NumberFormatter()
        )
        TextField(
          exerciseSet.reps.description,
          value: $exerciseSet.reps,
          formatter: NumberFormatter()
        )
        
        Button(
          action: { exerciseSet.complete.toggle() },
          label: { Image(systemName: exerciseSet.complete ? "checkmark.circle" : "checkmark") }
        )
        .foregroundColor(exerciseSet.complete ? .accentColor : .secondary)
        .buttonStyle(.plain)
        
      }
      .multilineTextAlignment(.center)
      .swipeActions {
        Button(
          role: .destructive,
          action: { viewStore.send(.removeSet(exerciseSet)) },
          label: { Label("Remove", systemImage: "trash") }
        )
      }
    }
  }
}

private func Video(_ url: URL) -> some View {
  VideoPlayer(player: AVPlayer(url: url))
    .aspectRatio(1920/1080, contentMode: .fit)
    .frame(width: 1920/5, height: 1080/5)
    .background(Color.white)
    .clipShape(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .strokeBorder(lineWidth: 1, antialiased: true)
        .foregroundColor(.secondary)
    )
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
}

private func AsyncIcon(_ url: URL) -> some View {
  AsyncImage(
    url: url,
    content: { $0.resizable().scaledToFill() },
    placeholder: ProgressView.init
  )
  .frame(width: 46, height: 46)
  .background(
    GroupBox { Color.clear }
  )
  .clipShape(
    RoundedRectangle(cornerRadius: 12, style: .continuous)
  )
  .overlay(
    RoundedRectangle(cornerRadius: 12, style: .continuous)
      .strokeBorder(lineWidth: 0.5, antialiased: true)
      .foregroundColor(.secondary)
  )
}

private struct ToggleButton<Label>: View where Label: View {
  @Binding var value: Bool
  @ViewBuilder let label: () -> Label
  
  var body: some View {
    Button(action: { value.toggle() }, label: label)
  }
}

// MARK: - Private Helpers
private extension ExerciseSet {
  var previousDescription: String {
    guard let previousReps = previousReps, let previousWeight = previousWeight
    else { return "_" }
    return "\(previousReps)x\(previousWeight) lbs"
  }
  var previousDescriptionColor: Color {
    guard let _ = previousReps, let _ = previousWeight
    else { return .secondary }
    return .primary
  }
}

private extension View {
  func setListRowSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View {
#if os(iOS)
    self.listRowSeparator(visibility, edges: edges)
#else
    self
#endif
  }
//  func setNavigationBarTitleDisplayMode(_ displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
//#if os(iOS)
//    self.navigationBarTitleDisplayMode(displayMode)
//#else
//    self
//#endif
//  }
}


// MARK: - SwiftUI Previews
struct TodayView_Previews: PreviewProvider {
  static var previews: some View {
    TodayView(store: TodayState.defaultStore)
      .previewDevice("iPad Pro (11-inch) (3rd generation)")
      .previewInterfaceOrientation(.landscapeLeft)
    
    TodayView(store: TodayState.defaultStore)
      .previewDevice("iPhone 12 Pro Max")
  }
}









