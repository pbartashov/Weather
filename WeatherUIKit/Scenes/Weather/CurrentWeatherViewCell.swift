//
//  CurrentWeatherView.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import SnapKit
import WeatherKit

final class CurrentWeatherViewCell: UICollectionViewCell {

    // MARK: - Properties

    // MARK: - Views

    private let arcView: UIImageView = {
        let image = UIImage(named: "Arc")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .brandYellowColor

        return imageView
    }()

    private let sunriseView: UIImageView = {
        let image = UIImage(named: "Sunrise")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .brandYellowColor

        return imageView
    }()

    private let sunriseLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    private let sunsetView: UIImageView = {
        let image = UIImage(named: "Sunset")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .brandYellowColor

        return imageView
    }()

    private let sunsetLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    private let minMaxTemperatureLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16)
        label.textColor = .red//.white
        label.textAlignment = .center

        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    private let iconStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20


        return stack
    }()

    private let cloudsView: ImagedLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center

        let image = UIImage(named: "Clouds")
        let imageView = UIImageView(image: image)

        return ImagedLabel(imageView: imageView, label: label, spacing: 5)
    }()

    private let windSpeedView: ImagedLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center

        let image = UIImage(named: "Wind")
        let imageView = UIImageView(image: image)

        return ImagedLabel(imageView: imageView, label: label, spacing: 5)
    }()

    private let humidityView: ImagedLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center

        let image = UIImage(named: "Water")
        let imageView = UIImageView(image: image)

        return ImagedLabel(imageView: imageView, label: label, spacing: 5)
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .brandYellowColor
        label.textAlignment = .center

        return label
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
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .brandBlue

        [cloudsView,
         windSpeedView,
         humidityView].forEach {
            iconStack.addArrangedSubview($0)
        }

        [arcView,
         sunriseView,
         sunsetView,
         minMaxTemperatureLabel,
         temperatureLabel,
         descriptionLabel,
         iconStack,
         sunriseLabel,
         timestampLabel,
         sunsetLabel
        ].forEach {
            contentView.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        arcView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalToSuperview().offset(33)
            make.trailing.equalToSuperview().offset(-31)
        }

        sunriseView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(145)
            make.leading.equalToSuperview().offset(25)
        }

        sunsetView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(145)
            make.trailing.equalToSuperview().offset(-24)
        }

        minMaxTemperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(33)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(minMaxTemperatureLabel.snp.bottom).offset(5)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom).offset(5)
        }

        iconStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
        }

        sunriseLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(167)
//            make.leading.equalToSuperview().offset(17)
            make.centerX.equalTo(arcView.snp.leading)
        }

        timestampLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(171)
            make.centerX.equalToSuperview()
        }

        sunsetLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(167)
//            make.trailing.equalToSuperview().offset(14)
            make.centerX.equalTo(arcView.snp.trailing)
        }
    }

    func setup(with weather: CurrentWeather,
               timeFormatter: DateFormatter,
               timestampFormatter: DateFormatter) {

        temperatureLabel.text = weather.tempFormatted
        descriptionLabel.text = weather.weather.weatherDescription

        cloudsView.text = weather.cloudsFormatted
        humidityView.text = weather.humidity
        windSpeedView.text = weather.windSpeedFormatted

//        if let sunrise = weather.sunrise {
//        let date = dateFormatter.date(from: weather.sunrise)



            sunriseLabel.text = timeFormatter.string(from: weather.sunrise)
//        } else {
//            sunriseLabel.text = nil
//        }

//        if let sunset = weather.sunset {
        sunsetLabel.text = timeFormatter.string(from: weather.sunset)
//        } else {
//            sunsetLabel.text = nil
//        }

        timestampLabel.text = timestampFormatter.string(from: weather.obTime)



    }

    func setupMinMaxTemperature(min: Int, max: Int) {
        let symbol = Settings.shared.temperatureSymbol
        minMaxTemperatureLabel.text = "\(min)\(symbol)/ \(max)\(symbol)"
    }
}
