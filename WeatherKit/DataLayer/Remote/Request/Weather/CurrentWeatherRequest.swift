//
//  CurrentWeatherRequest.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 17.09.2022.
//

enum CurrentWeatherRequest: RequestProtocol {
    case getWeatherFor(latitude: Double, longitude: Double)

    var path: String {
        "/v2.0/current"
    }

    var urlParams: [String: String?] {
        switch self {
            case let .getWeatherFor(latitude, longitude):
//                var params = ["page": String(page)]
//
//                urlParams["lat"] = String(latitude)
//                urlParams["lon"] = String(longitude)

                return [
                    "lat": String(latitude),
                    "lon": String(longitude)
                ]
        }
    }

    var requestType: RequestType {
        .get
    }
}
