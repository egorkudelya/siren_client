import SwiftUI


struct FailureView: View {
    @State private var start: Bool = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea().overlay(
                VStack() {
                    Image(systemName: "exclamationmark.triangle")
                        .font(Font.system(size: 50))
                        .foregroundColor(.white)
                        .offset(x: start ? 30 : 0)
                        .padding()
                    
                    Text("Nothing was found")
                        .font(.title)
                        .fontWeight(Font.Weight.medium)
                        .foregroundColor(.white)
                    
                    Spacer()
                        .frame(minHeight: 50, idealHeight: 50, maxHeight: 50)
                        .fixedSize()
                    
                    Button(
                        "Back Home",
                        action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    )
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(Capsule())
                },
                alignment: .center
            )
            .onAppear{
                start = true
                withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                    start = false
                }
            }
        }
    }
}

struct FailureView_Previews: PreviewProvider {
    static var previews: some View {
        FailureView()
    }
}
