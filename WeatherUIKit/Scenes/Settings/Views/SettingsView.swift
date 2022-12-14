//
//  SettingsView.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit
import WeatherKit
import Combine

final class SettingsView: UIView {

    enum Button {
        case setup
    }
    
    // MARK: - Properties

    private let settings: Settings
    
    var buttonTappedPublisher: AnyPublisher<Button, Never> {
        setupButton.tappedPublisher
    }
    
    private var buttonTappedSubscription: AnyCancellable?
    
    // MARK: - Views
    
    private let cloud1View: UIImageView = {
        let image = UIImage(named: "Cloud1")
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
    
    private let cloud2View: UIImageView = {
        let image = UIImage(named: "Cloud2")
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
    
    private let cloud3View: UIImageView = {
        let image = UIImage(named: "Cloud3")
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandLightGray
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.text = "Настройки"
        
        return label
    }()
    
    private let stackView: UIStackView =  {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        
        return stack
    }()
    
    private lazy var temperatureRow: SettingsRow<Settings.Temperature> = {
        let values: [Settings.Temperature] = [.celcius, .farenheit]
        return SettingsRow(title: "Температура", values: values)
    }()
    
    private lazy var windSpeedRow: SettingsRow<Settings.Speed> = {
        let values: [Settings.Speed] = [.miles, .kilometers]
        return SettingsRow(title: "Скорость ветра", values: values)
    }()
    
    private lazy var timeFormatRow: SettingsRow<Settings.TimeFormat> = {
        let values: [Settings.TimeFormat] = [.format12, .format24]
        return SettingsRow(title: "Формат времени", values: values)
    }()
    
    private lazy var notificationsRow: SettingsRow<Settings.Notifications> = {
        let values: [Settings.Notifications] = [.enabled, .disabled]
        return SettingsRow(title: "Уведомления", values: values)
    }()

    private lazy var setupButton: PublishedButton<Button> = {
        let button = PublishedButton(publishedValue: Button.setup)
        
        button.setTitle("Установить ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = .brandOrange
        button.titleLabel?.font = .systemFont(ofSize: 16)
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()

    // MARK: - LifeCicle
    
    init(settings: Settings = Settings.shared) {
        self.settings = settings
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Metods
    
    private func initialize() {
        [cloud1View,
         cloud2View,
         cloud3View,
         contentView
        ].forEach {
            self.addSubview($0)
        }
        
        [titleLabel,
         stackView,
         setupButton
        ].forEach {
            contentView.addSubview($0)
        }
        
        [temperatureRow,
         windSpeedRow,
         timeFormatRow,
         notificationsRow
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        setupLayouts()
        setupInitialValues()
        bindToButtons()
    }
    
    private func setupLayouts() {
        cloud1View.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(37)
            make.trailing.equalToSuperview().offset(-129.6)
            make.width.equalTo(531)
            make.height.equalTo(58)
        }
        
        cloud2View.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(121)
            make.leading.equalToSuperview().offset(195)
            make.width.equalTo(182)
            make.height.equalTo(94)
        }
        
        cloud3View.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-79)
            make.bottom.equalToSuperview().offset(-94.9)
            make.width.equalTo(216)
            make.height.equalTo(65)
            
        }
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(320)
            //            make.height.equalTo(330)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.leading.equalToSuperview().offset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ConstantsUI.topMargin)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        setupButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(37)
            make.leading.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().offset(-35)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    //    private func createTemperatureRow() -> SettingsRow {
    //        let celcius = UIAction(title: "C") { _ in () }
    //        let farenheit = UIAction(title: "F") { _ in () }
    //        return SettingsRow(title: "Температура", actions: [celcius, farenheit])
    //    }
    //
    //    private func createWindSpeedRow() -> SettingsRow {
    //        let miles = UIAction(title: "Mi") { _ in () }
    //        let kilometers = UIAction(title: "Km") { _ in () }
    //        return SettingsRow(title: "Скорость ветра", actions: [miles, kilometers])
    //    }
    //
    //    private func createTimeFormatRow() -> SettingsRow {
    //        let twelve = UIAction(title: "12") { _ in () }
    //        let twentyfour = UIAction(title: "24") { _ in () }
    //        return SettingsRow(title: "Формат времени", actions: [twelve, twentyfour])
    //    }
    //
    //    private func createNotificationsRow() -> SettingsRow {
    //        let on = UIAction(title: "On") { _ in () }
    //        let off = UIAction(title: "Off") { _ in () }
    //        return SettingsRow(title: "Уведомления", actions: [on, off])
    //    }
    
    
    private func setupInitialValues() {
        temperatureRow.setSelected(value: settings.temperature)
        windSpeedRow.setSelected(value: settings.speed)
        timeFormatRow.setSelected(value: settings.timeFormat)
        notificationsRow.setSelected(value: settings.notificationsState)
    }

    private func bindToButtons() {
        buttonTappedSubscription = setupButton.tappedPublisher
            .sink {[weak self] button in
                if case .setup = button {
                    self?.setupButtonTapped()
                }
            }
    }

    private func setupButtonTapped() {
        if let temperature = temperatureRow.currentValue {
            settings.temperature = temperature
        }
        
        if let windSpeed = windSpeedRow.currentValue {
            settings.speed = windSpeed
        }
        
        if let timeFormat = timeFormatRow.currentValue {
            settings.timeFormat = timeFormat
        }
        
        if let notifications = notificationsRow.currentValue {
            settings.notificationsState = notifications
        }

        settings.save()
    }
}
