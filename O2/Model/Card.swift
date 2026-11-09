import Foundation

enum CardState: String {
    case unscratched
    case scratched
    case activated
}

struct ScratchCard {
    var code: UUID?
    var state: CardState = .unscratched
}
