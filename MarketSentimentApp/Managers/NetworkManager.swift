//
//  NetworkManager.swift
//  PostsTestProject
//
//  Created by Muhammadjon Madaminov on 12/08/25.
//

import Foundation


protocol NetworkManagerProtocol {
    func fetchData<T:Decodable>(for endpoint: Endpoint) async throws -> T
    func postData<T>(for endpoint: Endpoint, data: Encodable?) async throws -> T where T : Decodable
}


final class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    private let jsonCoding: JSONCoding
    
    init(session: URLSession = .shared, jsonCoding: JSONCoding = DefaultJSONCoding()) {
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
        self.jsonCoding = jsonCoding
    }
    
    
    func handleHttpResponse(response: URLResponse, data: Data? = nil) throws {
        guard let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            #if DEBUG
            print("Error Raw response data: \(String(data: data ?? Data(), encoding: .utf8) ?? "Invalid data")")
            #endif
            throw NetworkErrors.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
    }
    
    func fetchData<T>(for endpoint: Endpoint) async throws -> T where T : Decodable {
        let request = try endpoint.urlRequest()
        let (data, response) = try await session.data(for: request)
        try handleHttpResponse(response: response, data: data)
        let responseModel = try jsonCoding.decoder.decode(T.self, from: data)
        return responseModel
    }
    
    
    func postData<T>(for endpoint: Endpoint, data: Encodable?) async throws -> T where T : Decodable {
        var request = try endpoint.urlRequest()
        if let data = data {
            request.httpBody = try jsonCoding.encoder.encode(data)
        }
        let (data, response) = try await session.data(for: request)
        try handleHttpResponse(response: response, data: data)
        let responseModel = try jsonCoding.decoder.decode(T.self, from: data)
        return responseModel
    }
}



enum NetworkErrors: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError(Error)
    case serverError(statusCode: Int)
    case compressionFailed
    case errorMessage(message: String)
}


extension NetworkErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The provided username is invalid. Please check the username and try again.", comment: "Message for invalid URL error")
        case .invalidResponse:
            return NSLocalizedString("The server response is invalid. Please try again later.", comment: "Message for invalid response error")
        case .invalidData:
            return NSLocalizedString("The received data is invalid or corrupted. Please try again.", comment: "Message for invalid data error")
        case .decodingError(let error):
            return NSLocalizedString("Failed to decode the data: \(error.localizedDescription). Please contact support.", comment: "Message for decoding error")
        case .serverError(let statusCode):
            return NSLocalizedString("The server returned an error with status code: \(statusCode). Please try again later.", comment: "Message for server error")
        case .compressionFailed:
            return NSLocalizedString("Error while compressing an image and uploading", comment: "compressionError")
        case .errorMessage(let message):
            return NSLocalizedString(message, comment: "error message")
        }
    }
}
