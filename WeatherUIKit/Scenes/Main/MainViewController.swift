//
//  MainViewController.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit
import WeatherKit
import Combine

public protocol LocationViewControllerFactoryProtocol {
    func makeDeniedViewController() -> UIViewController
    func makeRestrictedViewController() -> UIViewController
}

public final class MainViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: MainViewModel

    private var currentIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentIndex
            updatePageControlUI(forIndex: currentIndex)
            updateTitle()
        }
    }

    private var moveToIndex: Int = 0

    private let activePageIconImage = UIImage(named: "DotIcon")
    private let otherPageIconImage = UIImage(named: "DotIcon.fill")

    private var subscriptions: Set<AnyCancellable> = []

    // Factories
    private let makeWeatherViewController: (Int) -> WeathersViewController
    private let makeSettingsViewController: () -> SettingsViewController
    private let makeAddLocationViewController: () -> AddLocationViewController
    private let makeOnboardingViewController: () -> OnboardingViewController
    private let makeSearchLocationViewController: () -> SearchLocationViewController
    private let locationsViewControllerFactory: LocationViewControllerFactoryProtocol

    // MARK: - Views

    private var activity: UIActivityIndicatorView?

    private lazy var pageController: UIPageViewController =  {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageController.dataSource = self
        pageController.delegate = self

        return pageController
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect.zero)
        pageControl.numberOfPages = 1
        pageControl.pageIndicatorTintColor = .brandTextColor
        pageControl.currentPageIndicatorTintColor = .brandTextColor
        pageControl.preferredIndicatorImage = otherPageIconImage
        pageControl.setIndicatorImage(activePageIconImage, forPage: 0)

        return pageControl
    }()

    // MARK: - LifeCicle

    public init(
        viewModel: MainViewModel,
        weatherViewControllerFactory: @escaping (Int) -> WeathersViewController,
        settingsViewControllerFactory: @escaping ()-> SettingsViewController,
        addLocationViewControllerFactory: @escaping ()-> AddLocationViewController,
        onboardingViewControllerFactory: @escaping () -> OnboardingViewController,
        searchLocationViewControllerFactory: @escaping () -> SearchLocationViewController,
        locationsViewControllerFactory: LocationViewControllerFactoryProtocol
    ) {
        self.viewModel = viewModel
        self.makeWeatherViewController = weatherViewControllerFactory
        self.makeSettingsViewController = settingsViewControllerFactory
        self.makeAddLocationViewController = addLocationViewControllerFactory
        self.makeOnboardingViewController = onboardingViewControllerFactory
        self.makeSearchLocationViewController = searchLocationViewControllerFactory
        self.locationsViewControllerFactory = locationsViewControllerFactory

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        initialize()

        moveToAddLocationViewController()

        fetchLocations()
    }

    // MARK: - Metods

    private func initialize() {
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)

        pageController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(pageControl)

        pageControl.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.top).offset(87)
            make.centerX.equalToSuperview()
        }

        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)

        setupNavigationBar()
        setupBindings()
    }

    private func setupNavigationBar() {
        let menu = UIBarButtonItem(image: UIImage(named: "MenuIcon"),
                                   style: .done,
                                   target: self,
                                   action: #selector(menuTapped))

        menu.tintColor = .brandTextColor
        navigationItem.leftBarButtonItem = menu

        let add = UIBarButtonItem(image: UIImage(named: "PinIcon"),
                                  style: .plain,
                                  target: self,
                                  action: #selector(addTapped))

        add.tintColor = .brandTextColor
        navigationItem.rightBarButtonItem = add

        updateTitle()

        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: nil, style: .plain, target: nil, action: nil)

        let backImage = UIImage(named: "LeftArrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }

    @objc private func menuTapped() {
        showSettings()
    }

    @objc private func addTapped() {
        viewModel.handleAddLocation()
    }

    private func updatePageControlUI(forIndex currentIndex: Int) {
        (0..<pageControl.numberOfPages).forEach { (index) in
            let pageIcon = index == currentIndex ? activePageIconImage : otherPageIconImage
            pageControl.setIndicatorImage(pageIcon, forPage: index)
        }
    }

    private func updateTitle() {
        if currentIndex < viewModel.locations.count {
            title = viewModel.locations[currentIndex].cityName
        } else {
            title = "Добавьте новый город"
        }
    }

    private func setupBindings() {
        func bindViewModelToErrors() {
            viewModel.errorMessages
                .receive(on: DispatchQueue.main)
                .sink { error in
                    ErrorPresenter.shared.show(error: error)
                }
                .store(in: &subscriptions)
        }

        func bindViewModelLocations() {
            viewModel.$locations
                .map { $0.count + 1 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.numberOfPages, on: pageControl)
                .store(in: &subscriptions)

            viewModel.$locations
                .receive(on: DispatchQueue.main)
                .debounce(for: .seconds(0.3), scheduler: RunLoop.current)
                .sink { [weak self] locations in
                    guard let self = self else { return }
                    locations.isEmpty ?
                    self.moveToAddLocationViewController() :
                    self.moveToWeatherViewController(at: 0)

                }
                .store(in: &subscriptions)
        }

        func bindViewModelState() {
            viewModel.$mainSceneState
                .receive(on: DispatchQueue.main)
                .sink { [weak self] state in
                    self?.showWeather()

                    switch state {
                        case .showWeather:
                            break
                        case .showOnboarding:
                            self?.showOnboarding()

                        case .showSearchLocation:
                            self?.showSearchLocation()

                        case .showLocationDenied:
                            self?.showLocationDenied()

                        case .showLocationRestricted:
                            self?.showLocationRestricted()

                        case .showWeatherAt(let index):
                            self?.moveToWeatherViewController(at: index)

                        case .showWaitingLocation:
                            self?.showWaitingLocation()
                    }
                }
                .store(in: &subscriptions)
        }

        bindViewModelToErrors()
        bindViewModelLocations()
        bindViewModelState()
    }

    private func moveToWeatherViewController(at index: Int) {
        let viewController = makeWeatherViewController(index)
        pageController.setViewControllers([viewController],
                                          direction: .reverse,
                                          animated: true)
        currentIndex = index
    }

    private func moveToAddLocationViewController() {
        let viewController = makeAddLocationViewController()
        pageController.setViewControllers([viewController],
                                          direction: .reverse,
                                          animated: true)
        currentIndex = 0
    }

    private func showWeather() {
        if presentedViewController is OnboardingViewController ||
            presentedViewController is SearchLocationViewController {

            dismiss(animated: true)
        }

        if let activity = activity {
            activity.removeFromSuperview()
            self.activity = nil
        }
    }

    private func showOnboarding() {
        let onboarding = makeOnboardingViewController()
        onboarding.modalPresentationStyle = .fullScreen
        present(onboarding, animated: true)
    }

    private func showSearchLocation() {
        let search = makeSearchLocationViewController()
        present(search, animated: true)
    }

    private func showSettings() {
        let settings = makeSettingsViewController()
        navigationController?.pushViewController(settings, animated: true)
    }

    private func showLocationDenied() {
        let denied = locationsViewControllerFactory.makeDeniedViewController()
        present(denied, animated: true)
    }

    private func showLocationRestricted() {
        let restricted = locationsViewControllerFactory.makeRestrictedViewController()
        present(restricted, animated: true)
    }

    private func showWaitingLocation() {
        let activity = UIActivityIndicatorView(style: .large)
        activity.backgroundColor = .white
        activity.startAnimating()
        view.addSubview(activity)

        activity.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.activity = activity
    }

    private func fetchLocations() {
        Task {
            await viewModel.fetchLocations()
        }
    }
}

// MARK: - UIPageViewControllerDelegate methods
extension MainViewController: UIPageViewControllerDelegate {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        let firstPending = pendingViewControllers.first
        if let nextViewController = firstPending as? WeathersViewController {
            if let index = viewModel.locations.firstIndex(where: {
                $0.index == nextViewController.locationID
            }) {
                moveToIndex = index
            }
        } else if firstPending is AddLocationViewController {
            moveToIndex = currentIndex + 1
        }
    }

    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed {
            currentIndex = moveToIndex
        }
    }
}
// MARK: - UIPageViewControllerDataSource methods
extension MainViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentIndex < 1 {
            return nil
        } else {
            return makeWeatherViewController(currentIndex - 1)
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let maxLocationIndex = viewModel.locations.count - 1
        guard maxLocationIndex >= 0 else { return nil }
        
        switch currentIndex {
            case 0..<maxLocationIndex:
                return makeWeatherViewController(currentIndex + 1)

            case maxLocationIndex:
                return makeAddLocationViewController()

            default:
                return nil
        }
    }
}
