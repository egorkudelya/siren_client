import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: Image? = nil
    
    func load(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { uiImage in
            guard let uiImage = uiImage else {
                return
            }
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
}

struct RemoteArtwork: View {
    @StateObject private var imageLoader = ImageLoader()
    var urlString: String
    
    var body: some View {
        VStack {
            imageLoader.image?.resizable() ?? nil
        }
        .onAppear {
            imageLoader.load(fromURL: urlString)
        }
    }
}
