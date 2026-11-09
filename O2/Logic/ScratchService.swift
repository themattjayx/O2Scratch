import Foundation

struct ScratchService {
    private static let timeout = 2
    
    //Waits for specified amount of time and returns random UUID.
    static func scratch() async throws -> UUID {
        try await Task.sleep(for: .seconds(timeout))
        return UUID()
    }
}
