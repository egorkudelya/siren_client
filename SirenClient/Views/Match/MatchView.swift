import SwiftUI

struct MatchView: View {
    @State public var match: SearchMatch
    @State private var viewColor = Color.random()
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        viewColor.ignoresSafeArea().overlay(
            VStack(spacing: 15) {
                RemoteArtwork(urlString: match.artUrl)
                    .frame(width: getRect().width - 100, height: getRect().width - 100)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(12)
                    .padding()
                
                Text(match.name)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                HStack {
                    Text("**By:**")
                        .foregroundColor(.white)
                    Text(match.artists.map { $0.name }.joined(separator: ", "))
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text("**Genres:**")
                        .foregroundColor(.white)
                    Text(match.genres.map { $0.name }.joined(separator: ", "))
                        .foregroundColor(.white)
                }
                
                ProgressBarView(currentTs: Float(match.timestamp)! / 1e3,
                                totalLength: Float(match.duration)! / 1e3)
                .frame(width: getRect().width - 100)
                .padding(.bottom, 17)
                
                Button("Back Home", action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                .padding()
                .foregroundColor(.white)
                .background(Color(red: 0.27, green: 0.3, blue: 1))
                .clipShape(Capsule())
            }
                .padding(.bottom, 45)
        )
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

extension Color {
    static func random() -> Color {
        return Color(red: Double.random(in: 0.25...0.7), green: Double.random(in: 0.25...0.7), blue: Double.random(in: 0.25...0.5))
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(match: SearchMatch.defaultMatch)
    }
}
