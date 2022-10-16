//
//  RequestManager.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 17.09.2022.
//
//https://github.com/raywenderlich/rwi-materials/tree/editions/1.0/

public protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}


public final class RequestManager: RequestManagerProtocol {
    let apiManager: APIManagerProtocol
    let parser: DataParserProtocol
    //  let accessTokenManager: AccessTokenManagerProtocol

    public init(
        apiManager: APIManagerProtocol = APIManager(),
        parser: DataParserProtocol = DataParser()
        //    accessToken: AccessTokenManagerProtocol = AccessTokenManager()
    ) {
        self.apiManager = apiManager
        self.parser = parser
        //    self.accessTokenManager = accessToken
    }

    //  func requestAccessToken() async throws -> String {
    //    if accessTokenManager.isTokenValid() {
    //      return accessTokenManager.fetchToken()
    //    }

    //    let data = try await apiManager.perform(AuthTokenRequest.auth, authToken: "")
    //    let token: APIToken = try parser.parse(data: data)
    //    try accessTokenManager.refreshWith(apiToken: token)
    //    return token.bearerAccessToken
    //  }

    public func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        //    let authToken = try await requestAccessToken()
        let data = try await apiManager.perform(request)
//        print(String(data: data, encoding: .utf8))

        let decoded: T = try parser.parse(data: data)


//        print(String(data: data, encoding: .utf8))

        return decoded
    }
}
