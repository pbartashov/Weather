//
//  DailyWeatherView.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 10.10.2022.
//
import UIKit
import WeatherKit
import Combine

final class DailyWeatherView: UIScrollView {

    // MARK: - Properties
    
    private let viewModel: DailyWeatherViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    private let performAction = PassthroughSubject<DailyWeatherViewModel.Action, Never>()

    // MARK: - Views

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .brandTextColor

        return label
    }()

    private lazy var daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 88, height: 36)
        layout.minimumLineSpacing = 12

        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(DailyWeatherDaysCollectionViewCell.self,
                                forCellWithReuseIdentifier: DailyWeatherDaysCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)

        return collectionView
    }()

    private let noonPanel: WeatherPanelView = {
        let panel = WeatherPanelView()
        panel.backgroundColor = .brandLightGray
        panel.title = "День"

        return panel
    }()

    private let midnightPanel: WeatherPanelView = {
        let panel = WeatherPanelView()
        panel.backgroundColor = .brandLightGray
        panel.title = "Ночь"

        return panel
    }()

    private let sunAndMoonTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .brandTextColor
        label.text = "Солнце и Луна"

        return label
    }()

    private let moonphaseView: ImagedLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .brandTextColor

        let imageView = UIImageView()

        return ImagedLabel(imageView: imageView, label: label, spacing: 5)
    }()

    private let sunAndMoonStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 24
        stack.distribution = .fillEqually

        return stack
    }()

    private let sunAndMoonLineView: UIView = {
        let line = UIView()
        line.backgroundColor = .brandPurpleColor

        return line
    }()

    private let sunPanel: SunMoonPanel = {
        let panel = SunMoonPanel()
        panel.image = UIImage(named: "Sunny")

        return panel
    }()

    private let moonPanel: SunMoonPanel = {
        let panel = SunMoonPanel()
        panel.image = UIImage(named: "SunAndMoon")

        return panel
    }()

    private let airQualityTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .brandTextColor
        label.text = "Качество воздуха"

        return label
    }()

    private let airQualityIndexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textColor = .brandTextColor

        return label
    }()

    private let airQualityMarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white

        return label
    }()

    private let airQualityMarkBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true

        return view
    }()

    private let airQualityDesctriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .brandTextGrayColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    // MARK: - LifeCicle

    init(viewModel: DailyWeatherViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initialize()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {
        backgroundColor = .white

        [sunPanel,
         moonPanel
        ].forEach {
            sunAndMoonStackView.addArrangedSubview($0)
        }

        [titleLabel,
         daysCollectionView,
         noonPanel,
         midnightPanel,
         sunAndMoonTitleLabel,
         moonphaseView,
         sunAndMoonStackView,
         sunAndMoonLineView,
         airQualityTitleLabel,
         airQualityIndexLabel,
         airQualityMarkBackgroundView,
         airQualityMarkLabel,
         airQualityDesctriptionLabel
        ].forEach {
            self.addSubview($0)
        }

        setupLayouts()
        setupBindings()
    }

    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(16)
        }

        daysCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(36)
        }

        noonPanel.snp.makeConstraints { make in
            make.top.equalTo(daysCollectionView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-15)
        }

        midnightPanel.snp.makeConstraints { make in
            make.top.equalTo(noonPanel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-15)
        }

        sunAndMoonTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(midnightPanel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
        }

        moonphaseView.snp.makeConstraints { make in
            make.top.equalTo(midnightPanel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-15)
        }

        sunAndMoonStackView.snp.makeConstraints { make in
            make.top.equalTo(moonphaseView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-15)
        }

        sunAndMoonLineView.snp.makeConstraints { make in
            make.top.bottom.equalTo(sunAndMoonStackView)
            make.centerX.equalToSuperview()
            make.width.equalTo(0.5)
        }

        airQualityTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(sunAndMoonStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
        }

        airQualityIndexLabel.snp.makeConstraints { make in
            make.top.equalTo(airQualityTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(17)
        }

        airQualityMarkLabel.snp.makeConstraints { make in
            make.centerY.equalTo(airQualityIndexLabel)
            make.leading.equalTo(airQualityIndexLabel.snp.trailing).offset(33)
        }

        airQualityMarkBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(airQualityMarkLabel).offset(-3)
            make.leading.equalTo(airQualityMarkLabel).offset(-18)
            make.trailing.equalTo(airQualityMarkLabel).offset(17)
            make.bottom.equalTo(airQualityMarkLabel).offset(3)
        }

        airQualityDesctriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(airQualityIndexLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-15)
        }

        self.snp.makeConstraints { make in
            make.width.equalTo(noonPanel.snp.width).offset(16 + 15)
            make.bottom.equalTo(airQualityDesctriptionLabel).offset(23)
        }
    }

    private func setupBindings() {
        func bindSunPanel() {
            viewModel.$selectedNoonWeather
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] weather in
                    guard let self = self else { return }
                    self.setup(panel: self.noonPanel, with: weather)
                }
                .store(in: &subscriptions)
        }

        func bindMoonPanel() {
            viewModel.$selectedMidnightWeather
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] weather in
                    guard let self = self else { return }
                    self.setup(panel: self.midnightPanel, with: weather)
                }
                .store(in: &subscriptions)
        }

        func bindAirQuality() {
            viewModel.$airQualityIndex
                .map { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.text, on: airQualityIndexLabel)
                .store(in: &subscriptions)

            viewModel.$airQualityMark
                .map { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.text, on: airQualityMarkLabel)
                .store(in: &subscriptions)

            viewModel.$airQualityDesctription
                .map { $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.text, on: airQualityDesctriptionLabel)
                .store(in: &subscriptions)

            let colorPublisher = viewModel.$airQualityIndex
                .map { AirQualityColorConverter().color(for: $0) }
                .receive(on: DispatchQueue.main)

            colorPublisher
                .assign(to: \.backgroundColor, on: airQualityMarkLabel)
                .store(in: &subscriptions)

            colorPublisher
                .assign(to: \.backgroundColor, on: airQualityMarkBackgroundView)
                .store(in: &subscriptions)
        }

        bindSunPanel()
        bindMoonPanel()
        bindAirQuality()
    }

    func setupView() {
        let publisher = performAction.eraseToAnyPublisher()
        viewModel.subscribePerformAction(to: publisher)

        setSelectedWeather(at: 0)
        daysCollectionView.selectItem(at: .init(item: 0, section: 0),
                                      animated: true,
                                      scrollPosition: .centeredHorizontally)

        titleLabel.text = viewModel.location.cityName

        guard let weather = viewModel.selectedWeather else {
            return
        }

        moonphaseView.text = weather.moonphase
        moonphaseView.image = UIImage(named: "FullMoon")

        sunPanel.duration = weather.sunDuratuion
        sunPanel.riseEpoch = weather.sunriseEpoch
        sunPanel.setEpoch = weather.sunsetEpoch

        moonPanel.duration = weather.moonDuration
        moonPanel.riseEpoch = weather.moonriseEpoch
        moonPanel.setEpoch = weather.moonsetEpoch
   }

    func setup(panel: WeatherPanelView, with weather: WeatherViewModel) {
        panel.weatherIcon = weather.icon.icon
        panel.temperature = weather.temp
        panel.conditions = weather.conditions
        panel.feelslike = weather.feelslike
        panel.wind = "\(weather.windspeed) \(weather.windDirection)"
        panel.uvIndex = weather.uvIndex
        panel.precipprob = weather.precipprob
        panel.cloudcover = weather.cloudcoverWithPercentSign
    }

    private func setSelectedWeather(at index: Int) {
        performAction.send(.setSelectedWeather(at: index))
    }
}

// MARK: - UICollectionViewDataSource methods
extension DailyWeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.weathers.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DailyWeatherDaysCollectionViewCell.identifier,
                for: indexPath
            ) as? DailyWeatherDaysCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let weather = viewModel.weathers[indexPath.item]
        cell.setup(with: weather.dayMonthWeek)

        return cell
    }
}

extension DailyWeatherView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setSelectedWeather(at: indexPath.item)
    }
}

struct AirQualityColorConverter {
    func color(for index: String?) -> UIColor? {
        switch index {
            case "1":
                return .green
            case "2":
                return .yellow
            case "3":
                return .orange
            case "4":
                return .red
            case "5":
                return .brown
            default:
                return .clear
        }
    }
}
