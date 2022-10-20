//
//  DataParser.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 17.09.2022.
//

import Foundation

public protocol DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
}

public final class DataParser: DataParserProtocol {
    private let jsonDecoder: JSONDecoder

    public init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        if let key = WeatherPack.boxUserInfoKey {
            jsonDecoder.userInfo[key] = ParserBox()
        }

        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.dateDecodingStrategy = .secondsSince1970
    }

    public func parse<T: Decodable>(data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
