//
//  AirQualityRequest.swift
//  WeatherKit
//
//  Created by Павел Барташов on 13.10.2022.
//

enum AirQualityRequest: RequestProtocol {
    case getAirQualityForecastFor(location: WeatherLocation)

    var scheme: RequestScheme {
        .http
    }

    var host: String {
        AirQualityAPIConstants.host
    }

    var path: String {
//        let basePath =
        "/data/2.5/air_pollution/forecast"
//        switch self {
//            case let .getAirQualityForecastFor:
//                return "\(basePath)/\(location.latitude),\(location.longitude)/today"
//
//        }
    }

    var urlParams: [String: String?] {
        var urlParams = ["appid": AirQualityAPIConstants.clientId]
        switch self {
            case let .getAirQualityForecastFor(location):
                urlParams["lat"] = "\(location.latitude)"
                urlParams["lon"] = "\(location.longitude)"
    }

        return urlParams
    }

    var requestType: RequestType {
        .get
    }
}
