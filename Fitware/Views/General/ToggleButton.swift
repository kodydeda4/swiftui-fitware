import SwiftUI

/// Button that can toggle a boolean.
struct ToggleButton<Label>: View where Label: View {
  @Binding var toggle: Bool
  @ViewBuilder let label: () -> Label
  var body: some View { Button(action: { toggle.toggle() }, label: label) }
}

//
//extension Button where Label: View {
//  init(toggle: Binding<Bool>, label: () -> Label) {
//    self.init(action: { toggle.toggle() }, label: label)
//  }
//}
