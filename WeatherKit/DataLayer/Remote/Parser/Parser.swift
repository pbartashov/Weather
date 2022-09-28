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
//    private let dateFormatter: DateFormatter

    public init(
        jsonDecoder: JSONDecoder = JSONDecoder()
//        dateFormatter: DateFormatter = DateFormatter()
    ) {
//        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.dateDecodingStrategy = .secondsSince1970
//        self.jsonDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
////            guard let self = self else { return Date() }
//
//            // Parse the date using a custom `DateFormatter`
//            let container = try decoder.singleValueContainer()
//            let dateString = try container.decode(String.self)
//            guard let date = dateFormatter.date(from: dateString) else { return Date() }
//
//            let midnightThen = Calendar.current.startOfDay(for: date)
//            let millisecondsFromMidnight = date.timeIntervalSince(midnightThen)
//
//            let midnightToday = Calendar.current.startOfDay(for: Date())
//            let normalizedDate = midnightToday.addingTimeInterval(millisecondsFromMidnight)
//
//            return normalizedDate
//        })
        //        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

//        self.dateFormatter = dateFormatter

    }

    public func parse<T: Decodable>(data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
