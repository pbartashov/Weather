//
//  WeathersViewController.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit
import WeatherKit
import Combine

protocol HourlyWeatherViewControllerFactory {
    func makeHourlyWeatherViewController(for city: String,
                                         weathers: AnyPublisher<[WeatherViewModel], Never>
    ) -> HourlyWeatherViewController
}

public final class WeathersViewController: UICollectionViewController {
    
    // MARK: Section Definitions
    
    enum Section: Hashable {
        case loading
        case currentWeatherSection
        case hourlyWeatherSection
        case dailyWeatherSection([WeatherViewModel])
    }

    enum SupplementaryViewKind {
        static let hourlyWeatherHeader = "hourly"
        static let dailyWeatherHeader = "daily"
        static let removePageFooter = "remove"
    }
    
    // MARK: - Properties
    
    private let viewModel: WeathersViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    private var presentHourlyWeatherSubscription: AnyCancellable?
    
    public var locationID: Int {
        viewModel.location.index
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, WeatherCollectionItem>!
    private var sections = [Section]()
    
    @Published private var currentWeatherItem: WeatherCollectionItem?
    @Published private var hourlyWeatherItems: [WeatherCollectionItem]?
    @Published private var dailyWeatherSection: Section?
    
    // Factories
    private let hourlyWeatherViewControllerFactory: HourlyWeatherViewControllerFactory
    private let dailyWeatherViewControllerFactory: DailyWeatherViewControllerFactory
    
    // MARK: - LifeCicle
    
    init(viewModel: WeathersViewModel,
         hourlyWeatherViewControllerFactory: HourlyWeatherViewControllerFactory,
         dailyWeatherViewControllerFactory: DailyWeatherViewControllerFactory
    ) {
        self.viewModel = viewModel
        self.hourlyWeatherViewControllerFactory = hourlyWeatherViewControllerFactory
        self.dailyWeatherViewControllerFactory = dailyWeatherViewControllerFactory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        configureCollectionView()
        view = collectionView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        applySnapshot()
        bindViewModelToViews()
        fetchWeathers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.brandTextColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
    }
    
    // MARK: - Metods
    
    private func fetchWeathers() {
        Task {
            await viewModel.fetchWeathers()
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        collectionView.register(LoadingCell.self,
                                forCellWithReuseIdentifier: LoadingCell.identifier)
        
        collectionView.register(CurrentWeatherViewCell.self,
                                forCellWithReuseIdentifier: CurrentWeatherViewCell.identifier)
        
        collectionView.register(HourlyWeatherViewCell.self,
                                forCellWithReuseIdentifier: HourlyWeatherViewCell.identifier)
        
        collectionView.register(DailyWeatherViewCell.self,
                                forCellWithReuseIdentifier: DailyWeatherViewCell.identifier)
        
        collectionView.register(WeatherSectionHeaderView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKind.hourlyWeatherHeader,
                                withReuseIdentifier: WeatherSectionHeaderView.identifier)
        
        collectionView.register(WeatherSectionHeaderView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKind.dailyWeatherHeader,
                                withReuseIdentifier: WeatherSectionHeaderView.identifier)
        
        collectionView.register(RemovePageView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKind.removePageFooter,
                                withReuseIdentifier: RemovePageView.identifier)
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = .init(top: 112, left: 0, bottom: 16, right: 0)
        
        configureDataSource()
        configureRefreshControl()
    }
    
    private func configureRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action:
                                                    #selector(handleRefreshControl),
                                                 for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        fetchWeathers()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard !self.sections.isEmpty else { return nil }
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(44))
            let hourlyWeatherHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: SupplementaryViewKind.hourlyWeatherHeader,
                alignment: .topTrailing
            )
            
            let dailyWeatherHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: SupplementaryViewKind.dailyWeatherHeader,
                alignment: .topTrailing
            )
            
            let footerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(31)
            )
            let removePageFooterItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerItemSize,
                elementKind: SupplementaryViewKind.removePageFooter,
                alignment: .bottom
            )
            
            let section = self.sections[sectionIndex]
            switch section {
                case .loading:
                    // MARK: Loading Section Layout
                    fallthrough
                    
                case .currentWeatherSection:
                    // MARK: Current Weather Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalHeight(1))
                    
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                                                           heightDimension: .estimated(212))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                   subitems: [item])
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .groupPagingCentered
                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0,
                                                                    bottom: 28, trailing: 0)
                    return section
                    
                case .hourlyWeatherSection:
                    // MARK: Hourly Weather Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalHeight(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8,
                                                                 bottom: 0, trailing: 8)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(42 + 16),
                                                           heightDimension: .estimated(84))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                   subitems: [item])
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = [hourlyWeatherHeaderItem]
                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16,
                                                                    bottom: 32, trailing: 16)
                    return section
                    
                case .dailyWeatherSection:
                    // MARK: Daily Weather Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalHeight(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0,
                                                                 bottom: 8, trailing: 0)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .estimated(66))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                                 subitems: [item])
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16,
                                                                    bottom: 6, trailing: 16)
                    section.boundarySupplementaryItems = [dailyWeatherHeaderItem, removePageFooterItem]
                    
                    return section
            }
        }
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { [weak self]
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let section = self.sections[indexPath.section]
            switch section {
                case .loading:
                    return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier,
                                                              for: indexPath)
                    
                case .currentWeatherSection:
                    guard
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: CurrentWeatherViewCell.identifier,
                            for: indexPath
                        ) as? CurrentWeatherViewCell,
                        case .currentWeatherItem(let currentWeather) = self.currentWeatherItem
                    else {
                        return nil
                    }
                    cell.setup(with: currentWeather)
                    
                    if case .dailyWeatherSection(let dailyWeathers) = self.dailyWeatherSection,
                       let weather = dailyWeathers.first {
                        cell.setupMinMaxTemperature(with: weather)
                    }
                    
                    return cell
                case .hourlyWeatherSection:
                    guard
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: HourlyWeatherViewCell.identifier,
                            for: indexPath
                        ) as? HourlyWeatherViewCell,
                        case .hourlyWeatherItem(let hourlytWeathers) = self.hourlyWeatherItems?[indexPath.item]
                    else {
                        return nil
                    }
                    cell.setup(with: hourlytWeathers)
                    
                    return cell
                case .dailyWeatherSection:
                    guard
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: DailyWeatherViewCell.identifier,
                            for: indexPath
                        ) as? DailyWeatherViewCell,
                        case .dailyWeatherSection(let dailyWeathers) = self.dailyWeatherSection
                    else {
                        return nil
                    }
                    cell.setup(with: dailyWeathers[indexPath.item])
                    
                    return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let self = self else { return nil }
            switch kind {
                case SupplementaryViewKind.hourlyWeatherHeader:
                    guard
                        let headerView = collectionView.dequeueReusableSupplementaryView(
                            ofKind: SupplementaryViewKind.hourlyWeatherHeader,
                            withReuseIdentifier: WeatherSectionHeaderView.identifier,
                            for: indexPath
                        ) as? WeatherSectionHeaderView
                    else {
                        return nil
                    }
                    
                    headerView.setup(buttonTitle: "Подробнее на 24 часа")
                    self.presentHourlyWeatherSubscription = headerView
                        .buttonTappedPublisher
                        .eraseType()
                        .sink {[weak self] in
                            self?.presentHourlyWeather()
                        }
                    
                    return headerView
                    
                case SupplementaryViewKind.dailyWeatherHeader:
                    guard
                        let headerView = collectionView.dequeueReusableSupplementaryView(
                            ofKind: SupplementaryViewKind.dailyWeatherHeader,
                            withReuseIdentifier: WeatherSectionHeaderView.identifier,
                            for: indexPath
                        ) as? WeatherSectionHeaderView
                    else {
                        return nil
                    }
                    
                    let publisher = headerView.buttonTappedPublisher.eraseType()
                    self.viewModel.subscribeToggleForecastHorizon(to: publisher)
                    
                    let buttonTitle = "\(self.viewModel.toggleForecastHorizonTitle) дней"
                    headerView.setup(labelTitle: "Ежедневный прогноз", buttonTitle: buttonTitle)
                    
                    return headerView
                    
                case SupplementaryViewKind.removePageFooter:
                    guard
                        let footerView = collectionView.dequeueReusableSupplementaryView(
                            ofKind: SupplementaryViewKind.removePageFooter,
                            withReuseIdentifier: RemovePageView.identifier,
                            for: indexPath
                        ) as? RemovePageView
                    else {
                        return nil
                    }
                    
                    let publisher = footerView.buttonTappedPublisher.eraseType()
                    self.viewModel.subscribeRemovePage(to: publisher)
                    
                    return footerView
                    
                default:
                    return nil
            }
        }
    }
    
    private func bindViewModelToViews() {
        func bindViewModelToErrors() {
            viewModel.errorMessages
                .receive(on: DispatchQueue.main)
                .sink { error in
                    ErrorPresenter.shared.show(error: error)
                }
                .store(in: &subscriptions)
        }
        
        func bindViewModelToWeathers() {
            viewModel
                .$currentWeather
                .removeDuplicates()
                .compactMap { $0 }
                .map { WeatherCollectionItem.currentWeatherItem($0) }
                .assign(to: &$currentWeatherItem)
            
            viewModel
                .$hourlyWeather
                .removeDuplicates()
                .map { weathers in
                    weathers.map { WeatherCollectionItem.hourlyWeatherItem($0) }
                }
                .assign(to: &$hourlyWeatherItems)
            
            viewModel
                .$dailyWeather
                .removeDuplicates()
                .map { Section.dailyWeatherSection($0) }
                .assign(to: &$dailyWeatherSection)
        }
        
        func bindToCollectionView() {
            Publishers.MergeMany(
                $currentWeatherItem.eraseTypeAndDuplicates(),
                $hourlyWeatherItems.eraseTypeAndDuplicates(),
                $dailyWeatherSection.eraseTypeAndDuplicates()
            )
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.collectionView.refreshControl?.endRefreshing()
                self?.applySnapshot()
            }
            .store(in: &subscriptions)
        }
        
        bindViewModelToErrors()
        bindViewModelToWeathers()
        bindToCollectionView()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherCollectionItem>()
        
        if let currentWeatherItem = currentWeatherItem,
           case .currentWeatherItem(let weather) = currentWeatherItem {
            snapshot.appendSections([.currentWeatherSection])
            
            let item = WeatherCollectionItem.currentWeatherItem(weather)
            snapshot.appendItems([item], toSection: .currentWeatherSection)
        } else {
            snapshot.appendSections([.loading])
            snapshot.appendItems([WeatherCollectionItem.empty(UUID())], toSection: .loading)
        }
        
        if let hourlyWeatherItems = hourlyWeatherItems {
            snapshot.appendSections([.hourlyWeatherSection])
            
            snapshot.appendItems(hourlyWeatherItems, toSection: .hourlyWeatherSection)
        }
        
        if let dailyWeatherSection = dailyWeatherSection,
           case .dailyWeatherSection(let weathers) = dailyWeatherSection {
            snapshot.appendSections([dailyWeatherSection])
            
            let items = weathers.map { WeatherCollectionItem.dailyWeatherItem($0) }
            snapshot.appendItems(items, toSection: dailyWeatherSection)
        }
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
    
    private func presentHourlyWeather() {
        let hourlyWeatherPublisher = viewModel.$hourlyWeather.eraseToAnyPublisher()
        let hourlyViewController = hourlyWeatherViewControllerFactory
            .makeHourlyWeatherViewController(for: viewModel.location.cityName,
                                             weathers: hourlyWeatherPublisher)
        navigationController?.pushViewController(hourlyViewController, animated: true)
    }
    
    private func presentDailyWeather() {
        let dailyWeatherPublisher = viewModel.$dailyWeather.eraseToAnyPublisher()
        let dailyViewController = dailyWeatherViewControllerFactory
            .makeDailyWeatherViewController(for: viewModel.location,
                                            weathers: dailyWeatherPublisher)
        navigationController?.pushViewController(dailyViewController, animated: true)
    }
    
    // MARK: UICollectionViewDelegate
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            case 1:
                presentHourlyWeather()
                
            case 2:
                presentDailyWeather()
                
            default:
                break
        }
    }
}
