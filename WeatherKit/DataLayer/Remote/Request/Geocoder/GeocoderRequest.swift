//
//  GeocoderRequest.swift
//  WeatherKit
//
//  Created by Павел Барташов on 16.10.2022.
//

enum GeocoderRequest: RequestProtocol {
    case getAddressFor(latitude: Double, longitude: Double)
    case getCoordinatesFor(locality: String)

    var scheme: RequestScheme {
        .https
    }

    var host: String {
        LocationAPIConstants.host
    }

    var path: String {
        //        let basePath =
        "/1.x"
        //        switch self {
        //            case let .getAirQualityForecastFor:
        //                return "\(basePath)/\(location.latitude),\(location.longitude)/today"
        //
        //        }
    }

    var urlParams: [String: String?] {
        var urlParams = ["apikey": LocationAPIConstants.clientId,
                         "results": LocationAPIConstants.resultsCount,
                         "format": "json",
                         "kind": "locality",
                         "sco": "latlong"]
        switch self {
            case let .getAddressFor(latitude, longitude):
                urlParams["geocode"] = "\(latitude),\(longitude)"

            case let .getCoordinatesFor(locality):
                urlParams["geocode"] = locality
        }

        return urlParams
    }

    var requestType: RequestType {
        .get
    }
}

