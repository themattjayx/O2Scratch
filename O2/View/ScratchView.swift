import SwiftUI

struct ScratchView: View {

    @Binding var card: ScratchCard
    @State private var scratchTask: Task<Void, Never>?

    var body: some View {
        VStack {
            CardView(card: card)
            Button("Scratch", action: scratch)
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
                .fontWeight(.bold)
                .disabled(scratchTask != nil)
        }
        .onDisappear {                          //used for explicit cancellation, task modifier also possible
            scratchTask?.cancel()               //mark as cancelled
            scratchTask = nil
        }
    }

    private func scratch() {
        card = ScratchCard()
        scratchTask = Task {
            do {
                let code = try await ScratchService.scratch()
                try Task.checkCancellation()    //throw if cancelled

                card.code = code
                card.state = .scratched
            } catch {
                print("Scratching failed")
            }
            scratchTask = nil
        }
    }
}
