import SwiftUI

struct ActivateView: View {
    
    @Binding var card: ScratchCard
    @State private var alertError: Bool = false
    @State private var activating: Bool = false
    
    var body: some View {
        VStack {
            CardView(card: card)
            
            Button("Activate") {
                Task {
                    await activate()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .fontWeight(.bold)
            .disabled(activating || card.state != .scratched)
            
        }
        .alert("Activation Error", isPresented: $alertError){}
    }
    
    private func activate() async {
        guard let code = card.code else { return }
        activating = true
        defer { activating = false }
        switch await ActivationService.attempt(code: code) {
        case .activated:
            card.state = .activated
        case .failed, .rejected:
            alertError = true
        }
    }
}
