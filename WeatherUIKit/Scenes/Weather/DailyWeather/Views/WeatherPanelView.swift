//
//  WeatherPanelView.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 10.10.2022.
//

import UIKit

final class WeatherPanelView: UIView {

    // MARK: - Properties

    var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    var temperature: String? {
        get {
            temperatureLabel.text
        }
        set {
            temperatureLabel.text = newValue
        }
    }

    var weatherIcon: UIImage? {
        get {
            weatherIconView.image
        }
        set {
            weatherIconView.image = newValue
        }
    }

    var conditions: String? {
        get {
            conditionsLabel.text
        }
        set {
            conditionsLabel.text = newValue
        }
    }

    var feelslike: String? {
        get {
            feelslikeRow.valueText
        }
        set {
            feelslikeRow.valueText = newValue
        }
    }

    var wind: String? {
        get {
            windRow.valueText
        }
        set {
            windRow.valueText = newValue
        }
    }

    var uvIndex: String? {
        get {
            uvIndexRow.valueText
        }
        set {
            uvIndexRow.valueText = newValue
        }
    }

    var precipprob: String? {
        get {
            precipprobRow.valueText
        }
        set {
            precipprobRow.valueText = newValue
        }
    }

    var cloudcover: String? {
        get {
            cloudcoverRow.valueText
        }
        set {
            cloudcoverRow.valueText = newValue
        }
    }

    // MARK: - Views

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .brandTextColor

        return label
    }()

    private let weatherIconView: UIImageView = {
        return UIImageView()
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textColor = .brandTextColor
        label.textAlignment = .center

        return label
    }()

    private let iconAndTemperatureStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.alignment = .center

        return stack
    }()

    private let conditionsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .brandTextColor
        label.textAlignment = .center

        return label
    }()

    private lazy var feelslikeRow: ImagedLabeledValue = {
        makeRow(imageName: "Temperature", labelText: "По ощущениям")
    }()

    private lazy var feelslikeRowBottomLine: RectangularDashedView = {
        makeRowBottomLine()
    }()

    private lazy var windRow: ImagedLabeledValue = {
        makeRow(imageName: "Wind", labelText: "Ветер")
    }()

    private lazy var windRowBottomLine: RectangularDashedView = {
        makeRowBottomLine()
    }()

    private lazy var uvIndexRow: ImagedLabeledValue = {
        makeRow(imageName: "Sunny", labelText: "УФ индекс")
    }()

    private lazy var uvIndexRowBottomLine: RectangularDashedView = {
        makeRowBottomLine()
    }()

    private lazy var precipprobRow: ImagedLabeledValue = {
        makeRow(imageName: "Rain", labelText: "Дождь")
    }()

    private lazy var precipprobRowBottomLine: RectangularDashedView = {
        makeRowBottomLine()
    }()

    private lazy var cloudcoverRow: ImagedLabeledValue = {
        makeRow(imageName: "Clouds", labelText: "Облачность")
    }()

    private lazy var cloudcoverRowBottomLine: RectangularDashedView = {
        makeRowBottomLine()
    }()

    private let rowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12

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
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        [weatherIconView,
         temperatureLabel
        ].forEach {
            iconAndTemperatureStackView.addArrangedSubview($0)
        }

        [feelslikeRow,
         feelslikeRowBottomLine,
         windRow,
         windRowBottomLine,
         uvIndexRow,
         uvIndexRowBottomLine,
         precipprobRow,
         precipprobRowBottomLine,
         cloudcoverRow,
         cloudcoverRowBottomLine

        ].forEach {
            rowStack.addArrangedSubview($0)
        }

        [titleLabel,
         iconAndTemperatureStackView,
         conditionsLabel,
         rowStack,
        ].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.leading.equalToSuperview().offset(15)
        }

        iconAndTemperatureStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ConstantsUI.topMargin)
            make.centerX.equalToSuperview()
        }

        conditionsLabel.snp.makeConstraints { make in
            make.top.equalTo(iconAndTemperatureStackView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        rowStack.snp.makeConstraints { make in
            make.top.equalTo(conditionsLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }

    private func makeRow(imageName: String, labelText: String) -> ImagedLabeledValue {
        let row = ImagedLabeledValue()
        row.spacing = 15
        row.imageSectionWidth = 54
        row.trailingMargin = 15
        row.centerLabel.font = .systemFont(ofSize: 14)
        row.centerLabel.textColor = .brandTextColor

        row.rightLabel.font = .systemFont(ofSize: 18)
        row.rightLabel.textColor = .brandTextColor

        row.image = UIImage(named: imageName)
        row.labelText = labelText

        return row
    }

    private func makeRowBottomLine() -> RectangularDashedView {
        let bottomLine = RectangularDashedView()
        bottomLine.dashWidth = 0.5
        bottomLine.dashColor = .brandPurpleColor
        bottomLine.dashLength = 1
        bottomLine.betweenDashesSpace = 0

        return bottomLine
    }
}
