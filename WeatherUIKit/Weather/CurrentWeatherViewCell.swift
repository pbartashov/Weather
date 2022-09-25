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

    private let temperatureLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right

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

        contentView.backgroundColor = .brandBlue

        [temperatureLabel
        ].forEach {
            contentView.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        temperatureLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setup(with weather: CurrentWeather) {
        temperatureLabel.numberOfLines = 0

        temperatureLabel.text = "\(weather.temp)"

    }
}
