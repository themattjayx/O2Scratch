import Foundation

struct ActivationService {
    
    private struct Response: Codable {
        let ios: String
    }
    
    enum Result {
        case activated, rejected, failed
    }
    
    static let baseURL = URL(string: "https://api.o2.sk/version")
    

    // Creates URL for activation
    static func url(code: UUID) throws -> URL {
        guard let baseURL else { throw URLError(.badURL) }
        let url = baseURL.appending(queryItems: [URLQueryItem(name: "code", value: code.uuidString)])
        print(url.absoluteString)
        return url
    }

    
    // Retrieves the ios version from response
    static func parse(data: Data) throws -> String {
        return try JSONDecoder().decode(Response.self, from: data).ios
    }

    
    // Sends activation code with GET and returns ios version
    static func activate(code: UUID) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: url(code: code))
        return try parse(data: data)
    }
    
    // Checks validity of ios version
    static func valid(ios: String) throws -> Bool {
        guard let version = Double(ios) else { throw URLError(.cannotDecodeContentData)}
        return version > 6.1
    }

    // Turns a version string into result
    static func result(for ios: String) -> Result {
        do {
            return try valid(ios: ios) ? .activated : .rejected
        } catch {
            return .failed
        }
    }

    // Attempts to connect to server
    static func attempt(code: UUID) async -> Result {
        do {
            let ios = try await activate(code: code)
            return result(for: ios)
        } catch {
            return .failed
        }
    }
}
