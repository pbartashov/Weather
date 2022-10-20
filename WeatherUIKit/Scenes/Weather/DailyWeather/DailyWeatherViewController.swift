//
//  DailyWeatherViewController.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 09.10.2022.
//

import UIKit
import WeatherKit
import Combine

protocol DailyWeatherViewControllerFactory {
    func makeDailyWeatherViewController(for location: WeatherLocation,
                                        weathers: AnyPublisher<[WeatherViewModel], Never>
    ) -> DailyWeatherViewController
}

final class DailyWeatherViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: DailyWeatherViewModel
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Views

    private lazy var dailyWeatherView: DailyWeatherView = DailyWeatherView(viewModel: viewModel)

    // MARK: - LifeCicle

    init(viewModel: DailyWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        dailyWeatherView.setupView()
    }

    // MARK: - Metods

    private func initialize() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .brandTextColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.brandTextGrayColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]

        title = "Дневная погода"

        view.addSubview(dailyWeatherView)

        setupLayouts()
        bindViewModel()
    }

    private func setupLayouts() {
        dailyWeatherView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bindViewModel() {
        viewModel.errorMessages
            .receive(on: DispatchQueue.main)
            .sink { error in
                ErrorPresenter.shared.show(error: error)
            }
            .store(in: &subscriptions)
    }
}
