import SwiftUI

struct SearchMatchView: View {
    @State private var animatedGradient = false
    @State private var currentMessage = "Listening..."
    @StateObject private var viewModel = SearchMatchViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .cyan, .purple], startPoint: .topLeading , endPoint: .bottomTrailing)
                .hueRotation (.degrees (animatedGradient ? 45 : 0))
                .ignoresSafeArea()
            
            VStack {
                Text(self.currentMessage)
                    .font(.system(size: 31).weight(.regular))
                    .foregroundColor(.white)
                    .id(self.currentMessage)
                    .transition(.opacity.animation(.easeOut(duration: 0.4)))
                    .onChange(of: viewModel.isLoading) { value in
                        guard value else {
                            return
                        }
                        self.currentMessage = "Looking for a match..."
                    }
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

