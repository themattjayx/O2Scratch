import Testing
import Foundation

@testable import O2


@MainActor
struct ActivationServiceTests {
    
    @Test("Url cotains the desired code")
    func urlCode() throws {
        let code = UUID()
        let baseURL = try #require(ActivationService.baseURL)
        let url = try ActivationService.url(code: code)
        let components = try #require (URLComponents(url: url, resolvingAgainstBaseURL: false))
        
        #expect(url.absoluteString.hasPrefix(baseURL.absoluteString))
        #expect(components.queryItems == [URLQueryItem(name: "code", value: code.uuidString)])
    }
    
    @Test("Parses the ios version from JSON format")
    func iosDetermined() throws {
        let data = Data(#"{"ios":"6.2"}"#.utf8)
        #expect(try ActivationService.parse(data: data) == "6.2")
    }

    @Test("Throws when the ios string field is missing")
    func iosMissing() {
        let data = Data(#"{"ios":1}"#.utf8)
        #expect(throws: DecodingError.self) {
            try ActivationService.parse(data: data)
        }
    }

    @Test("Throws on non-JSON data")
    func notJSON() {
        #expect(throws: DecodingError.self) {
            try ActivationService.parse(data: Data("hello".utf8))
        }
    }

    @Test("Supperted version activates", arguments: ["6.2", "7", "14.0"])
    func activates(ios: String) {
        #expect(ActivationService.result(for: ios) == .activated)
    }

    @Test("Unsupported version is rejected", arguments: ["6.1", "6.0", "5"])
    func rejects(ios: String) {
        #expect(ActivationService.result(for: ios) == .rejected)
    }

    @Test("Non-numeric version fails", arguments: ["", "abc", "---"])
    func garbageFails(ios: String) {
        #expect(ActivationService.result(for: ios) == .failed)
    }
}

@MainActor
struct ScratchServiceTests {
    @Test("Scratch returns a code")
    func scratchReturnsUUID() async throws {
        let id = try await ScratchService.scratch()
        #expect(!id.uuidString.isEmpty)
    }

    @Test("Scratch cancels with a task")
    func scratchCancels() async {
        let task = Task {
            try await ScratchService.scratch()
        }
        task.cancel()
        await #expect(throws: CancellationError.self) {
            try await task.value
        }
    }
}
