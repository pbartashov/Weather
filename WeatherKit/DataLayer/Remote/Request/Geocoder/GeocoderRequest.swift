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
        "/1.x"
    }

    var urlParams: [String: String?] {
        let apikey = String(data: LocationAPIConstants.clientId, encoding: .utf8)
        var urlParams = ["apikey": apikey,
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
