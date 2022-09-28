//
//  CurrentWeatherRequest.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 17.09.2022.
//

enum WeatherRequest: RequestProtocol {
    case getCurrentDayWeatherFor(latitude: Double, longitude: Double)
//    case getWeatherFor7Days(latitude: Double, longitude: Double)
//    case getWeatherFor15Days(latitude: Double, longitude: Double)


    var path: String {
        let basePath = "/VisualCrossingWebServices/rest/services/timeline"
        switch self {
            case let .getCurrentDayWeatherFor(latitude, longitude):
                return "\(basePath)/\(latitude),\(longitude)/today"

        }
    }

//https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/vladivostok/today?unitGroup=us&include=current%2Chours&key=YQ8FCBUW53CPXSWQKMQVPLFZY&contentType=json

    var urlParams: [String: String?] {
        var urlParams = ["key": APIConstants.clientId,
                         "lang": APIConstants.language]

        switch self {
            case .getCurrentDayWeatherFor:
                //                var params = ["page": String(page)]
                //
                //                urlParams["lat"] = String(latitude)
                //                urlParams["lon"] = String(longitude)
                urlParams["include"] = "current,hours"

                //                return urlParams[
                //                    "lat": String(latitude),
                //                    "lon": String(longitude)
                //                ]

        }

        return urlParams
    }

    var requestType: RequestType {
        .get
    }
}
