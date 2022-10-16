//
//  MainViewController.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit
import WeatherKit
import Combine

public final class MainViewController: UIViewController {

    // MARK: - Properties

    private lazy var pageController: UIPageViewController =  {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageController.dataSource = self
        pageController.delegate = self

        return pageController
    }()

    private let viewModel: MainViewModel


    private var currentIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentIndex
            updatePageControlUI(forIndex: currentIndex)
            updateTitle()
        }
    }
    private var moveToIndex: Int = 0
//    private var moveFromIndex: Int = 0
//    private var nextIndex: Int = 0
//    private var previousIndex: Int = 0
    let activePageIconImage = UIImage(named: "DotIcon")
    let otherPageIconImage = UIImage(named: "DotIcon.fill")

    // Factories
    let makeWeatherViewController: (Int) -> WeathersViewController
    let makeSettingsViewController: () -> SettingsViewController
    let makeAddLocationViewController: () -> AddLocationViewController
    let makeOnboardingViewController: () -> OnboardingViewController
    let makeSearchLocationViewController: () -> SearchLocationViewController

//    private var locations = [LocationWeather(index: 0, cityName: "London"),
//                        LocationWeather(index: 1, cityName: "Vladivostok"),
//                        LocationWeather(index: 2, cityName: "San Diego")
//    ]

    private var subscriptions: Set<AnyCancellable> = []

//    private var weatherViewControllers: [UIViewController] = [WeatherViewController(),
//                                                      OnboardingViewController(), SettingsViewController()]

    // MARK: - Views

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

//    init() {
//        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
//    }

    public init(
        viewModel: MainViewModel,
        weatherViewControllerFactory: @escaping (Int) -> WeathersViewController,
        settingsViewControllerFactory: @escaping ()-> SettingsViewController,
        addLocationViewControllerFactory: @escaping ()-> AddLocationViewController,
        onboardingViewControllerFactory: @escaping () -> OnboardingViewController,
        searchLocationViewControllerFactory: @escaping () -> SearchLocationViewController
    ) {
        self.viewModel = viewModel
        self.makeWeatherViewController = weatherViewControllerFactory
        self.makeSettingsViewController = settingsViewControllerFactory
        self.makeAddLocationViewController = addLocationViewControllerFactory
        self.makeOnboardingViewController = onboardingViewControllerFactory
        self.makeSearchLocationViewController = searchLocationViewControllerFactory

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }



    public override func viewDidLoad() {
        super.viewDidLoad()








//        dataSource = self
//        delegate = self
//
//        setViewControllers([WeatherViewController(locationWeather: locations[0])],
//                                                      direction: .forward, animated: true)


        let viewController = makeAddLocationViewController()
        pageController.setViewControllers([viewController],
                                          direction: .reverse,
                                          animated: true)

        //        if !viewModel.locations.isEmpty {
        //            let viewConrtoller = makeWeatherViewController(0)
//            pageController.setViewControllers([viewConrtoller],
//                                              direction: .forward,
//                                              animated: true)
//        } else {
//            let viewConrtoller = UIViewController()
//            pageController.setViewControllers([viewConrtoller],
//                                              direction: .forward,
//                                              animated: true)
//        }

//        pageController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)

        pageController.view.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.trailing.bottom.equalToSuperview()
            make.edges.equalToSuperview()
        }

        view.addSubview(pageControl)

        pageControl.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.top).offset(87)
            make.centerX.equalToSuperview()
        }








        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)

        setupNavigationBar()
        setupBindings()
    }




//    public override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        //        guard let pageControl = pageControl else { return }
//        //
//        //        let pageControlSize = pageControl.size(forNumberOfPages: weatherViewControllers.count)
//        //        pageControl.frame = CGRect(
//        //            origin: CGPoint(x: view.frame.midX - pageControlSize.width / 2, y: view.frame.maxY - pageControlSize.height),
//        //            size: pageControlSize
//        //        )
//
//    }

    // MARK: - Metods

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
//        self.navigationController?.navigationBar.backItem?.title = "Custom"
    }

    @objc private func menuTapped() {
        showSettings()
    }

    @objc private func addTapped() {
        viewModel.handleAddLocation()
    }

    private func updatePageControlUI(forIndex currentIndex: Int) {

//        pageControl.pageIndicatorTintColor = .systemYellow
//        pageControl.currentPageIndicatorTintColor = .black

        (0..<pageControl.numberOfPages).forEach { (index) in
            let pageIcon = index == currentIndex ? activePageIconImage : otherPageIconImage
            pageControl.setIndicatorImage(pageIcon, forPage: index)
        }


//        title = viewModel.locations[currentIndex].cityName

    }

    private func updateTitle() {
        if currentIndex < viewModel.locations.count {
            title = viewModel.locations[currentIndex].cityName
        } else {
            title =  "Добавьте новый город"
        }
    }

    private func setupBindings() {
        viewModel.$locations
            .map { $0.count + 1 }
            .receive(on: DispatchQueue.main)
            .assign(to: \.numberOfPages, on: pageControl)
            .store(in: &subscriptions)

        viewModel.$locations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locations in
                guard let self = self, !locations.isEmpty else { return }
                let viewController = self.makeWeatherViewController(0)
                self.pageController.setViewControllers([viewController],
                                                       direction: .reverse,
                                                  animated: true)
                self.currentIndex = 0
            }
            .store(in: &subscriptions)

        viewModel.$mainSceneState
            .sink { [weak self] state in
                self?.showWeather()

                switch state {
                    case .showWeather:
                        break
                    case .showOnboarding:
                        self?.showOnboarding()

                    case .showSearchLocation:
                        self?.showSearchLocation()
                }
            }
            .store(in: &subscriptions)
    }

    private func showWeather() {
        if presentedViewController is OnboardingViewController ||
            presentedViewController is SearchLocationViewController {
            #warning("alert is self dissmissed")

            dismiss(animated: true)
        }
    }

    private func showOnboarding() {
        let onboarding = makeOnboardingViewController()
        onboarding.modalPresentationStyle = .fullScreen
        present(onboarding, animated: true)
    }

    private func showSearchLocation() {
//        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
//        ac.addTextField()
//
//        ac.aut
//
//        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
//            let answer = ac.textFields![0]
//            // do something interesting with "answer" here
//        }
//
//        ac.addAction(submitAction)
//
//        present(ac, animated: true)
//
//return


        let search = makeSearchLocationViewController()
//        search.modalPresentationStyle = .currentContext
        present(search, animated: true)
//        navigationController?.pushViewController(search, animated: true)
    }

    private func showSettings() {
        let settings = makeSettingsViewController()
        //        settings.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(settings, animated: true)
        //        present(settings, animated: true)

    }
}




extension MainViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
//        guard let nextViewController = pendingViewControllers.first as? WeathersViewController else { return }
//        moveToIndex = nextViewController.locationID
        let firstPending = pendingViewControllers.first
        if let nextViewController = firstPending as? WeathersViewController {
            moveToIndex = nextViewController.locationID
        } else if firstPending is AddLocationViewController {
            moveToIndex = currentIndex + 1
        }
    }


    public func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed {
            currentIndex = moveToIndex
        }

//        guard let selectedViewController = pageViewController.viewControllers?.first else { return }
//
//        if let indexOfSelectViewController = indexOf(selectedViewController) {
//            pageControl?.currentPage = indexOfSelectViewController
//        }
    }


    
}



extension MainViewController: UIPageViewControllerDataSource {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//
//        guard currentIndex > 0 else { return nil }
//
//        currentIndex -= 1
//
//        return weatherViewControllers[currentIndex]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard currentIndex < weatherViewControllers.count - 1 else { return nil }
//
//        currentIndex += 1
//
//        return weatherViewControllers[currentIndex]
//    }
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        let indexOfCurrentPageViewController = locations.firstIndex { $0.index == currentIndex } ?? 0

        if currentIndex < 1 {
            return nil // To show there is no previous page
        } else {
            // Previous UIViewController instance
            return makeWeatherViewController(currentIndex - 1)

//            WeatherViewController(viewModel: viewModel.locations[currentIndex - 1])
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

//        let indexOfCurrentPageViewController = locations.firstIndex { $0.index == currentIndex } ?? locations.count
//        if currentIndex >= viewModel.locations.count - 1 {
//            return nil // To show there is no next page
//        } else {
//            // Next UIViewController instance
////            moveToIndex = currentIndex + 1
//            return makeWeatherViewController(currentIndex + 1)
////            return WeatherViewController(viewModel: viewModel.locations[currentIndex + 1])
//        }
//        let addLocationIndex =
        let maxLocationIndex = viewModel.locations.count - 1

        switch currentIndex {
            case 0..<maxLocationIndex:
                return makeWeatherViewController(currentIndex + 1)

            case maxLocationIndex:
                return makeAddLocationViewController()

            default:
                return nil
        }
    }

//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return self.weatherViewControllers.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        0
//    }
}
