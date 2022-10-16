//
//  APIManager.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 17.09.2022.
//
//https://github.com/raywenderlich/rwi-materials/tree/editions/1.0/
import Foundation

public protocol APIManagerProtocol {
    //  func perform(_ request: RequestProtocol, authToken: String) async throws -> Data
    func perform(_ request: RequestProtocol) async throws -> Data
    //  func requestToken() async throws -> Data
}

public final class APIManager: APIManagerProtocol {
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    public func perform(_ request: RequestProtocol) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.createURLRequest())
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidServerResponse
        }
        return data
    }

    //  func requestToken() async throws -> Data {
    //    try await perform(AuthTokenRequest.auth)
    //  }
}
