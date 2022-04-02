import SwiftUI
import GymVisual
import ComposableArchitecture

public struct TodayView: View {
  public let store: Store<TodayState, TodayAction>
  @State var search = String()
  @State var selection: Int? = Exercise.bicyclePilates.id
  private var title: String {
    Set(exercises.flatMap(\.bodyparts).map(\.rawValue)).joined(separator: ", ")
  }
  
  let exercises: [Exercise] = [
    .bicyclePilates,
    .bicepsLegConcentrationCurlUpperArms,
    .abRollerCrunchWaist,
    .elbowFlexion,
    .aboveHeadChestStretchFemaleChest,
    .archerPullUpBack
  ]
  
  public init(store: Store<TodayState, TodayAction>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationView {
      List {
        Section {
          VStack(alignment: .leading, spacing: 8) {
            Text("push 2".capitalized)
              .font(.subheadline)
              .foregroundColor(.accentColor)
            
            Text(title)
              .font(.headline)
              .listRowSeparator(.hidden)
            
            ProgressView(value: 75, total: 100)
            
            Text("John's Push Pull Split")
              .foregroundStyle(.secondary)
            
          }
        }
        .listRowSeparator(.hidden, edges: .bottom)
        .listRowBackground(EmptyView())
        
        ForEach(exercises) { exercise in
          NavigationLink(
            tag: exercise.id,
            selection: $selection,
            destination: { ExerciseDetailView(exercise: exercise) },
            label: { ExerciseLabelView(exercise: exercise) }
          )
        }
      }
      .navigationTitle("Today")
      .navigationBarTitleDisplayMode(.large)
      //    .listStyle(.grouped)
      .listStyle(.inset)
      .toolbar {
        Button(action: {}) {
          Label("Menu", systemImage: "ellipsis")
        }
      }
    }
  }
}


private struct ExerciseSet: Identifiable {
  let id = UUID()
  var weight: Int
  var reps: Int
  var complete: Bool
  var previousWeight: Int?
  var previousReps: Int?
}

private extension Exercise {
  var photo: URL {
    URL(string: "https://www.id-design.com/previews_640_360/\(media).jpg")!
  }
  var video: URL {
    URL(string: "https://www.id-design.com/videos/\(media).mp4")!
  }
}

// MARK: - Views...

private struct ExerciseLabelView: View {
  let exercise: Exercise
  let complete = Bool.random()
  
  var body: some View {
    HStack {
      AsyncImage(
        url: exercise.photo,
        content: { $0.resizable().scaledToFill() },
        placeholder: ProgressView.init
      )
      .frame(width: 46, height: 46)
      .background(GroupBox { Color.clear })
      .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
      .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
        .strokeBorder(lineWidth: 0.5, antialiased: true)
        .foregroundColor(.secondary))
      
      VStack(alignment: .leading, spacing: 6) {
        Text(exercise.name.capitalized)
          .bold()
        
        Text(exercise.bodyparts.map(\.rawValue.capitalized).joined(separator: ", "))
          .font(.caption2)
          .foregroundStyle(.secondary)
      }
    }
    .padding(.vertical, 4)
    .lineLimit(1)
  }
}


private struct ExerciseDetailView: View {
  let exercise: Exercise
  @State var exerciseSets = [
    ExerciseSet(weight: 35, reps: 16, complete: false, previousWeight: 20, previousReps: 10),
    ExerciseSet(weight: 45, reps: 14, complete: false),
    ExerciseSet(weight: 50, reps: 20, complete: false),
    ExerciseSet(weight: 25, reps: 12, complete: false),
  ]
  
  var body: some View {
    List {
      header
        .listRowBackground(EmptyView())
        .listRowSeparator(.hidden)
        .padding(.bottom, 32)
      
      
      
      Section(
        content: {
          SetView(sets: $exerciseSets)
          
        },
        header: {
          //          Text("Today's Routine")
        },
        footer: {
          Button(action: {}) {
            Label("Add Set", systemImage: "plus.circle.fill")
          }
          .buttonStyle(.plain)
          .foregroundColor(.accentColor)
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.trailing)
          .listRowSeparator(.hidden, edges: .bottom)
        }
      )
      
    }
    .lineLimit(1)
    .navigationBarTitleDisplayMode(.inline)
    .listStyle(.inset)
    .toolbar {
      ToolbarItemGroup {
        HStack {
          Button(action: {}) {
            Label("History", systemImage: "clock")
          }
          Button(action: {}) {
            Label("Love", systemImage: "heart")
          }
        }
      }
    }
  }
  
  @ViewBuilder
  var header: some View {
    HStack {
      //      video
      title
      Spacer()
    }
  }
  
  //  var video: some View {
  //    VideoPlayer(url: exercise.video, play: .constant(true))
  //      .autoReplay(true)
  //      .aspectRatio(1920/1080, contentMode: .fit)
  //      .frame(width: 1920/5, height: 1080/5)
  //      .background(Color.white)
  //      .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  //      .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
  //        .strokeBorder(lineWidth: 1, antialiased: true)
  //        .foregroundColor(.secondary))
  //      .background(Color.white)
  //      .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  //  }
  
  var title: some View {
    VStack(alignment: .leading) {
      Text(exercise.name)
        .font(.title)
        .fontWeight(.semibold)
      
      Text(exercise.bodyparts.map(\.rawValue).joined(separator: ", "))
        .font(.title2)
        .fontWeight(.semibold)
        .foregroundColor(.accentColor)
      
      Text(exercise.type.rawValue.uppercased())
        .fontWeight(.semibold)
        .foregroundColor(.secondary)
      
      Text(exercise.equipment.rawValue)
        .font(.subheadline)
        .foregroundColor(.secondary)
      
      VStack(alignment: .leading) {
        Text(exercise.primaryMuscles.map(\.rawValue).joined(separator: ", "))
        Text(exercise.secondaryMuscles.map(\.rawValue).joined(separator: ", "))
      }
      .padding(.top)
      .font(.subheadline)
      .foregroundColor(.secondary)
    }
    .padding(.leading)
  }
}

private struct SetView: View {
  @Binding var sets: [ExerciseSet]
  var previousDescription: (ExerciseSet) -> String = { exSet in
    guard let previousReps = exSet.previousReps,
          let previousWeight = exSet.previousWeight
    else { return "_" }
    
    return "\(previousReps)x\(previousWeight) lbs"
  }
  var previousDescriptionColor: (ExerciseSet) -> Color = { exSet in
    guard let previousReps = exSet.previousReps,
          let previousWeight = exSet.previousWeight
    else { return .secondary }
    return .primary
  }
  
  var body: some View {
    header
    //      .listRowSeparator(.hidden, edges: .top)
    content
  }
  
  
  var header: some View {
    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
      Text("Set")
      Text("Previous")
      Text("Weight")
      Text("Reps")
      Text("Done")
    }
    .foregroundStyle(.secondary)
  }
  
  var content: some View {
    ForEach(Array(zip($sets, sets.indices)), id: \.1) { $exSet, index in
      LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
        Text("\(index+1)")
        Text(previousDescription(exSet)).foregroundColor(previousDescriptionColor(exSet))
        TextField("\(exSet.weight)", value: $exSet.weight, formatter: NumberFormatter())
        TextField("\(exSet.reps)", value: $exSet.reps, formatter: NumberFormatter())
        Button(action: { exSet.complete.toggle() }) {
          Image(systemName: exSet.complete ? "checkmark.circle" : "checkmark")
        }
        .foregroundColor(exSet.complete ? .accentColor : .secondary)
        .buttonStyle(.plain)
      }
      .multilineTextAlignment(.center)
      .swipeActions {
        Button(
          role: .destructive,
          action: {},
          label: { Label("Remove", systemImage: "trash") }
        )
      }
    }
  }
}

struct TodayView_Previews: PreviewProvider {
  static var previews: some View {
    TodayView(store: TodayState.defaultStore)
  }
}
