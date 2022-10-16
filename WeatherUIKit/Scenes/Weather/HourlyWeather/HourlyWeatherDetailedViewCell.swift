//
//  HourlyWeatherDetailedViewCell.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 05.10.2022.
//

import SnapKit
import WeatherKit
import UIKit

final class HourlyWeatherDetailedViewCell: UICollectionViewCell {

    // MARK: - Properties

    // MARK: - Views

    private let dateLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = .brandTextColor

        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .brandTextGrayColor

        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = .brandTextColor

        return label
    }()

    private let conditionsRow: HourlyWeatherDetailedViewCellRow = {
        let row = HourlyWeatherDetailedViewCellRow()

        return row
    }()

    private let windRow: HourlyWeatherDetailedViewCellRow = {
        let row = HourlyWeatherDetailedViewCellRow()
        row.image = UIImage(named: "Wind")
        row.centerText = "Ветер"

        return row
    }()

    private let precipitationRow: HourlyWeatherDetailedViewCellRow = {
        let row = HourlyWeatherDetailedViewCellRow()
        row.image = UIImage(named: "Fog")
        row.centerText = "Атмосферные осадки"

        return row
    }()

    private let cloudsRow: HourlyWeatherDetailedViewCellRow = {
        let row = HourlyWeatherDetailedViewCellRow()
        row.image = UIImage(named: "Cloudy")
        row.centerText = "Облачность"

        return row
    }()

    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
//        stack.distribution = .equalCentering

        return stack
    }()

    let lineView: UIView = {
        $0.backgroundColor = .brandPurpleColor

        return $0
    }(UIView())





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
        contentView.backgroundColor = .brandLightGray

        [conditionsRow,
         windRow,
         precipitationRow,
         cloudsRow
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        [dateLabel,
         timeLabel,
         temperatureLabel,
         stackView,
         lineView
        ].forEach {
            contentView.addSubview($0)
        }

//        contentView.addSubview(stackView)
        //        [timeLabel,
        //         weatherIconView,
        //         temperatureLabel
        //        ].forEach {
        //            contentView.addSubview($0)
        //        }

        setupLayouts()
    }

    private func setupLayouts() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(16)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(22)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.leading.equalToSuperview().offset(90)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-8)
        }

        lineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }

    func setup(with weather: WeatherViewModel) {
        //               formatter: WeartherFormatterProtocol) {
        //               timeFormatter: DateFormatter,
        //               timestampFormatter: DateFormatter) {

        dateLabel.text = weather.weekDayMonth
        timeLabel.text = weather.time
        temperatureLabel.text = weather.temp

        conditionsRow.image = weather.icon.icon
        conditionsRow.centerText = "\(weather.conditions). По ощущению \(weather.feelslike)"

        windRow.rightText = "\(weather.windspeed) \(weather.windDirection)"
        precipitationRow.rightText = weather.precipprob
        cloudsRow.rightText = weather.cloudcoverWithPercentSign

        #warning("shows wrong info")
    }
}


