import SwiftUI

struct ProgressBarView: View {
    @State var currentTs : Float
    @State var totalLength : Float
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private func timeFormatter(position: Int) -> String {
        let minutes = position / 60
        let seconds = position % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
    
    var body: some View {
        ProgressView(value: currentTs, total: totalLength) {
            HStack {
                Text(timeFormatter(position: Int(currentTs)))
                    .font(Font.system(size: 12))
                    .padding(.leading, 4)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(timeFormatter(position: Int(totalLength)))
                    .font(Font.system(size: 12))
                    .padding(.trailing, 4)
                    .foregroundColor(.white)
            }
        }
            .onReceive(timer) { _ in
                if currentTs < totalLength {
                    currentTs += 1
                }
            }
            .progressViewStyle(LinearProgressViewStyle(tint: .white))
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(currentTs: 0, totalLength: 240)
    }
}
