import SwiftUI

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
      destination: {
        List {
          ForEach(allCases) { item in
            Button(
              action: {
                if selection.contains(item) {
                  selection.remove(item)
                } else {
                  selection.insert(item)
                }
              },
              label: {
                HStack {
                  Image(systemName: "checkmark")
                    .opacity(selection.contains(item) ? 1 : 0)
                  
                  Text(item.description)
                    .foregroundColor(.primary)
                }
              }
            )
          }
        }
        .navigationTitle(title)
      },
      label: {
        HStack {
          Text(title)
          Spacer()
          Text(selection.count == allCases.count ? "All Selected" : "\(selection.count)/\(allCases.count)")
            .foregroundColor(.gray)
        }
      }
    )
  }
}
