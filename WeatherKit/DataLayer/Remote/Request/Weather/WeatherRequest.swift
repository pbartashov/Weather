//
//  WeatherRequest.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 17.09.2022.
//

enum WeatherRequest: RequestProtocol {
    case getCurrentDayWeatherFor(location: WeatherLocation)
    case getForecastWeatherFor(location: WeatherLocation, dateInterval: DateInterval)
    case getHourlyWeatherFor(location: WeatherLocation, date: Date)
    case getCurrentWeatherFor(latitude: Double, longitude: Double)

    var scheme: RequestScheme {
        .https
    }

    var host: String {
        WeatherAPIConstants.host
    }

    var path: String {
        let basePath = "/VisualCrossingWebServices/rest/services/timeline"
        switch self {
            case let .getCurrentDayWeatherFor(location):
                return "\(basePath)/\(location.latitude),\(location.longitude)/today"

            case let .getForecastWeatherFor(location, dateInterval):
                let dateFormatter = makeDateFormatter(for: location)

                let since = dateFormatter.string(from: dateInterval.start)
                let till = dateFormatter.string(from: dateInterval.end)
                return "\(basePath)/\(location.latitude),\(location.longitude)/\(since)/\(till)"

            case let .getHourlyWeatherFor(location: location, date: date):
                let dateFormatter = makeDateFormatter(for: location)
                let dateString = dateFormatter.string(from: date)

                return "\(basePath)/\(location.latitude),\(location.longitude)/\(dateString)/\(dateString)"

            case let .getCurrentWeatherFor(latitude, longitude):
                return "\(basePath)/\(latitude),\(longitude)/today"
        }
    }

    //https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/vladivostok/today?unitGroup=us&include=current%2Chours&key=YQ8FCBUW53CPXSWQKMQVPLFZY&contentType=json

    var urlParams: [String: String?] {
        let key = String(data: WeatherAPIConstants.clientId, encoding: .utf8)
        var urlParams = ["key": key,
                         "lang": WeatherAPIConstants.language,
                         "unitGroup": "metric",
                         "iconSet": "icons2"]

        switch self {
            case .getCurrentDayWeatherFor:
                urlParams["include"] = "current,hours"

            case .getForecastWeatherFor:
                urlParams["include"] = "days"

            case .getHourlyWeatherFor:
                urlParams["include"] = "hours"

            case .getCurrentWeatherFor:
                urlParams["include"] = "current"
        }

        return urlParams
    }

    var requestType: RequestType {
        .get
    }

    private func makeDateFormatter(for location: WeatherLocation) -> DateFormatter {
        let dateFormatter = DateFormatter()
        if let timeZone = location.timeZone {
            dateFormatter.timeZone = .init(identifier: timeZone)
        }

        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter
    }
}
