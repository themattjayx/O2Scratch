import SwiftUI

struct CardView: View {
    var card: ScratchCard?
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(Gradient(colors: [.blue, .cyan]))
                .overlay(alignment: .bottom) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding()
                        .scaleEffect(card?.state == .activated ? 1 : 0)
                }
            Text(codeText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(8)
                .mask { Circle().scale(card?.code == nil ? 0 : 6) }
        }
        .padding(20)
        .animation(card?.code == nil ? nil : .smooth(duration: 1), value: card?.state)
    }
    
    private var codeText: String {
        guard let code = card?.code?.uuidString else { return ""}
        let split = 19
        return code.prefix(split) + "\n" + code.dropFirst(split)
    }
}

#Preview {
    CardView()
}
