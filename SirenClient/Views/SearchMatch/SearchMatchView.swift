import SwiftUI

struct SearchMatchView: View {
    @State private var animatedGradient = false
    @StateObject private var viewModel = SearchMatchViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .cyan, .purple], startPoint: .topLeading , endPoint: .bottomTrailing)
                .hueRotation (.degrees (animatedGradient ? 45 : 0))
                .ignoresSafeArea()
            VStack {
                Text("Looking for a match...")
                    .font(.title)
                    .fontWeight(Font.Weight.medium)
                    .foregroundColor(.white)
            }
            
            if viewModel.isFailure {
                FailureView()
                    .transition(AnyTransition.move(edge: .leading)
                        .combined(with: .opacity)
                        .animation(.easeInOut(duration: 0.2)))
            }
            else if let track = viewModel.match {
                MatchView(match: track)
                    .transition(AnyTransition.move(edge: .leading)
                        .combined(with: .opacity)
                        .animation(.easeInOut(duration: 0.4)))
            }
        }
        .onAppear {
            viewModel.matchFixedBuffer()
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
                animatedGradient.toggle()
            }
        }
    }
}

struct SearchMatchView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

