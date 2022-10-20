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
        "/data/2.5/air_pollution/forecast"
    }

    var urlParams: [String: String?] {
        let appid = String(data: AirQualityAPIConstants.clientId, encoding: .utf8)
        var urlParams = ["appid": appid]
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
