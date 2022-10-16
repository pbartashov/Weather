//
//  WeatherRequest.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 17.09.2022.
//

enum WeatherRequest: RequestProtocol {
//    case getCurrentDayWeatherFor(latitude: Double, longitude: Double)
    case getCurrentDayWeatherFor(location: WeatherLocation)
    case getForecastWeatherFor(location: WeatherLocation, dateInterval: DateInterval)
    case getHourlyWeatherFor(location: WeatherLocation, date: Date)
//    case getForecastWeatherFor(latitude: Double, longitude: Double, since: Date, till: Date)
//    case getWeatherFor7Days(latitude: Double, longitude: Double, since: Date, till: Date)
//    case getWeatherFor15Days(latitude: Double, longitude: Double)

//    var dateFormatter: DateFormatter {
//        let datetimeFormatter = DateFormatter()
//        datetimeFormatter.locale = Locale(identifier: "ru_RU")
//        datetimeFormatter.timeZone = .init(identifier: )
//
//        if case .format12 = format {
//            timeFormatter.dateFormat = "hh:mm a"
//            datetimeFormatter.dateFormat = "hh:mm a, E dd MMMM"
//    }

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
//            case .getWeatherFor7Days(latitude: let latitude, longitude: let longitude):
//                return "\(basePath)/\(latitude),\(longitude)/next7days"
//            case .getWeatherFor15Days(latitude: let latitude, longitude: let longitude):
//                return "\(basePath)/\(latitude),\(longitude)"

            case let .getHourlyWeatherFor(location: location, date: date):
                let dateFormatter = makeDateFormatter(for: location)
                let dateString = dateFormatter.string(from: date)

                return "\(basePath)/\(location.latitude),\(location.longitude)/\(dateString)/\(dateString)"
        }
    }

//https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/vladivostok/today?unitGroup=us&include=current%2Chours&key=YQ8FCBUW53CPXSWQKMQVPLFZY&contentType=json

    var urlParams: [String: String?] {
        var urlParams = ["key": WeatherAPIConstants.clientId,
                         "lang": WeatherAPIConstants.language,
                         "unitGroup": "metric",
                         "iconSet": "icons2"]

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
            case .getForecastWeatherFor:
                urlParams["include"] = "days"
//            case .getWeatherFor7Days, .getWeatherFor15Days:
//                urlParams["include"] = "days"

            case .getHourlyWeatherFor:
                urlParams["include"] = "hours"
        }

        return urlParams
    }

    var requestType: RequestType {
        .get
    }

    private func makeDateFormatter(for location: WeatherLocation) -> DateFormatter {
        let dateFormatter = DateFormatter()
        //                dateFormatter.locale = Locale(identifier: "ru_RU")
        if let timeZone = location.timeZone {
            dateFormatter.timeZone = .init(identifier: timeZone)
        }

        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter
    }
}
