import SwiftUI

struct LoadingAnimationView: View {
    @State private var animatedGradient = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .indigo, .pink],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .hueRotation (.degrees (animatedGradient ? 45 : 0))
            .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .padding(35)
                            .foregroundColor(Color.white)
                    }
                }
                .padding(.top, 5)
                Spacer()
            }
            Text("Looking for a match...")
                .font(.title)
                .fontWeight(Font.Weight.regular)
                .foregroundColor(.white)
                .animation(nil)
        }
        .onAppear {
            withAnimation(.linear(duration: 0.85).repeatForever(autoreverses: true)) {
                animatedGradient.toggle()
            }
        }
    }
}

struct LoadingAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingAnimationView()
    }
}
