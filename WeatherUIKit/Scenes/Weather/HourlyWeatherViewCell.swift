//
//  HourlyWeatherViewCell.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import SnapKit
import WeatherKit

final class HourlyWeatherViewCell: UICollectionViewCell {

    // MARK: - Properties

    // MARK: - Views

    private let timeLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center

        return label
    }()

    private let weatherIconView: UIImageView = {
        return UIImageView()
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center

        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalCentering

        return stack
    }()

    // MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {
        contentView.layer.cornerRadius = 22
        contentView.layer.masksToBounds = true

        [timeLabel,
         weatherIconView,
         temperatureLabel].forEach {
            stackView.addArrangedSubview($0)
        }

        contentView.addSubview(stackView)
//        [stackView
//        ].forEach {
//            contentView.addSubview($0)
//        }

        setupLayouts()
    }

    private func setupLayouts() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    func setup(with weather: WeatherViewModel) {
        //               formatter: WeartherFormatterProtocol) {
        //               timeFormatter: DateFormatter,
        //               timestampFormatter: DateFormatter) {

        temperatureLabel.text = weather.temp
//        weatherIconView.image = weather.icon
        timeLabel.text = weather.time

        //        temperatureLabel.text = formatter.format(temperature: weather.temp)
        ////        temperatureLabel.text = weather.tempFormatted
        //        descriptionLabel.text = weather.conditions
        //
        //        cloudsView.text = formatter.format(cloudcover: weather.cloudcover)
        ////        cloudsView.text = weather.cloudsFormatted
        //        windSpeedView.text = formatter.format(speed: weather.windspeed)
        ////        windSpeedView.text = weather.windSpeedFormatted
        //        humidityView.text = formatter.format(humidity: weather.humidity)
        //
        ////        if let sunrise = weather.sunrise {
        ////        let date = dateFormatter.date(from: weather.sunrise)
        //
        //
        //        sunriseLabel.text = formatter.format(time: weather.sunriseEpoch)
        ////            sunriseLabel.text = timeFormatter.string(from: weather.sunriseEpoch)
        ////        } else {
        ////            sunriseLabel.text = nil
        ////        }
        //
        ////        if let sunset = weather.sunset {
        //        sunsetLabel.text = formatter.format(time: weather.sunsetEpoch)
        ////        sunsetLabel.text = timeFormatter.string(from: weather.sunsetEpoch)
        ////        } else {
        ////            sunsetLabel.text = nil
        ////        }
        //
        //        timestampLabel.text = formatter.format(dateTime: weather.datetimeEpoch)
        ////        timestampLabel.text = timestampFormatter.string(from: weather.datetimeEpoch)
        //


    }

    //    func setupMinMaxTemperature(min: Int, max: Int) {
    //        let symbol = Settings.shared.temperatureSymbol
    //        minMaxTemperatureLabel.text = "\(min)\(symbol)/ \(max)\(symbol)"
    //    }
}
