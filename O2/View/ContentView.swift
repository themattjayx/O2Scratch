import SwiftUI

struct ContentView: View {
    @State var card = ScratchCard()
    
    var body: some View {
        NavigationStack {
            ZStack {
                CardView()
                VStack{
                    Text(card.state.rawValue.uppercased())
                        .padding(.bottom, 20)
                    
                    NavigationLink("Scratch") {
                        ScratchView(card: $card)
                    }
                    NavigationLink("Activate") {
                        ActivateView(card: $card)
                    }
                }
                .buttonStyle(.bordered)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    ContentView()
}
