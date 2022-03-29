import SwiftUI
import Exercise

struct CustomPickerView<T>: View

where T: Hashable,
      T: Identifiable,
      T: CustomStringConvertible {
  
  let title: String
  let allCases: [T]
  @Binding var selection: Set<T>
  
  init(
    _ title: String,
    _ allCases: [T],
    _ selection: Binding<Set<T>>
  ) {
    self.title = title
    self.allCases = allCases
    self._selection = selection
  }
  
  var body: some View {
    NavigationLink(
      destination: { destination },
      label: { label }
    )
  }
  
  var label: some View {
    HStack {
      Text(title)
      Spacer()
      Text(selection.count == allCases.count ? "All Selected" : "\(selection.count)/\(allCases.count)")
        .foregroundColor(.gray)
    }
  }
  
  var destination: some View {
    ScrollView {
      LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4)) {
        ForEach(allCases, content: item)
      }
    }
    .padding()
    .navigationTitle(title)
  }
  
  func item(item: T) -> some View {
    Button(
      action: {
        if selection.contains(item) {
          selection.remove(item)
        } else {
          selection.insert(item)
        }
      }
    ) {
      VStack {
        Image(systemName: "swift")
          .resizable()
          .scaledToFit()
          .foregroundColor(
            selection.contains(item) ? .white : .gray
          )
          .padding(20)
          .frame(width: 75, height: 75)
          .background(
            selection.contains(item) ? Color.accentColor : Color.gray.opacity(0.1)
          )
          .clipShape(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
          )
        
        Text(item.description)
          .lineLimit(1)
          .font(.subheadline)
      }
    }
    .padding(.bottom)
    .buttonStyle(.plain)
  }
}


private enum Example:
  String,
  Hashable,
  Identifiable,
  CustomStringConvertible,
  CaseIterable {
  
  var id: String {
    rawValue
  }
  var description: String {
    String(repeating: rawValue, count: 5)
  }
  
  case a
  case bb
  case ccc
  case dddd
  case eeeee
  case ffffff
}


struct CustomPickerView_Previews: PreviewProvider {
  static var previews: some View {
    CustomPickerView(
      "Title",
      Example.allCases,
      .constant(Set())
    )
    .destination
  }
}
