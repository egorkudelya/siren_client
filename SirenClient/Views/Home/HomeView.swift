import SwiftUI

struct HomeView: View {
    @State var viewColor = Color.blue
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.purple,  Color(red: 0.3627, green: 0.5392, blue: 0.9), .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                NavigationLink(destination: SearchMatchView()
                    .navigationBarBackButtonHidden(true),
                               label: {
                    Image(systemName: "waveform.circle")
                        .font(.system(size: 190).weight(.thin))
                        .symbolVariant(.fill)
                        .background(.white, in: Circle().inset(by: 15))
                        .foregroundStyle(.tint)
                    
                })
                .padding(.top, 100)
                
            }
            .navigationTitle("Tap to start listening")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
