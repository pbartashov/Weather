//
//  DailyWeatherViewCell.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import SnapKit
import WeatherKit

final class DailyWeatherViewCell: UICollectionViewCell {

    // MARK: - Properties

    // MARK: - Views

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .brandTextGrayColor

        return label
    }()

    private let precipitationView: ImagedLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .brandPurpleColor
        label.textAlignment = .center

        let image = UIImage(named: "Rain")
        let imageView = UIImageView(image: image)

        return ImagedLabel(imageView: imageView, label: label, spacing: 5)
    }()

    private let leftStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
//        stack.distribution = .fill
        stack.alignment = .center

        return stack
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .brandTextColor
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingMiddle
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center

        return label
    }()

    private let chevronView: UIImageView = {
        let image = UIImage(named: "Chevron")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black

        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return imageView
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
        contentView.backgroundColor = .brandLightGray


        [dateLabel,
         precipitationView].forEach {
            leftStackView.addArrangedSubview($0)
        }

        [leftStackView,
         descriptionLabel,
         temperatureLabel,
         chevronView
        ].forEach {
            contentView.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        leftStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(53)
            make.bottom.equalToSuperview().offset(-10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftStackView.snp.trailing).offset(3)
            make.centerY.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { make in
            make.leading.equalTo(descriptionLabel.snp.trailing).offset(3)
            make.centerY.equalToSuperview()
        }

        chevronView.snp.makeConstraints { make in
            make.leading.equalTo(temperatureLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        //        timeLabel.snp.makeConstraints { make in
        //            make.top.equalToSuperview().offset(15)
        //            make.centerX.equalToSuperview()
        //        }
        //
        //        weatherIconView.snp.makeConstraints { make in
        //            make.top.equalTo(timeLabel.snp.bottom).offset(7)
        //            make.centerX.equalToSuperview()
        //        }
        //
        //
        //
        //        temperatureLabel.snp.makeConstraints { make in
        //            make.top.equalToSuperview().offset(58)
        //            make.centerX.equalToSuperview()
        //            make.bottom.equalToSuperview().offset(-8)
        //        }

    }

    func setup(with weather: WeatherViewModel) {
        //               formatter: WeartherFormatterProtocol) {
        //               timeFormatter: DateFormatter,
        //               timestampFormatter: DateFormatter) {

        dateLabel.text = weather.dayMonth
        precipitationView.text = weather.precipprob
        descriptionLabel.text = weather.conditions
        temperatureLabel.text = "\(weather.tempmin)-\(weather.tempmaxUnsigned)"

    }
}
