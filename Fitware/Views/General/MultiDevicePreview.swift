import SwiftUI

/// Create previews for multiple devices.
struct MultiDevicePreview<Content>: View where Content: View  {
  var previewDevices: [PreviewDevice] = [.iPhone13ProMax, .mac]
  @ViewBuilder let content: () -> Content
  
  var body: some View {
    ForEach(previewDevices, id: \.rawValue) {
      content()
        .previewDevice($0)
    }
  }
}


struct MultiDevicePreview_Previews: PreviewProvider {
  static var previews: some View {
    MultiDevicePreview {
      Text("Hello World")
    }
  }
}
