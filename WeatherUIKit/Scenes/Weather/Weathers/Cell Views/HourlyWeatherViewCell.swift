//
//  HourlyWeatherViewCell.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import SnapKit
import WeatherKit

final class HourlyWeatherViewCell: UICollectionViewCell {

    // MARK: - Views

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.lineBreakMode = .byClipping
        label.numberOfLines = 2

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
        stack.alignment = .center

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
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.brandLightPurple.cgColor

        [timeLabel,
         weatherIconView,
         temperatureLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        contentView.addSubview(stackView)

        setupLayouts()
    }

    private func setupLayouts() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    func setup(with weather: WeatherViewModel) {
        timeLabel.text = weather.time
        weatherIconView.image = weather.icon.icon
        temperatureLabel.text = weather.temp

        if weather.isHighLighted {
            contentView.backgroundColor = .brandPurpleColor
            timeLabel.textColor = .white
            temperatureLabel.textColor = .white
        } else {
            contentView.backgroundColor = .white
            timeLabel.textColor = .brandTextColor
            temperatureLabel.textColor = .brandTextColor
        }
    }
}
