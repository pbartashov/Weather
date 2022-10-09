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
//    func makeHourlyWeatherViewController(for city: String, weathers: [WeatherViewModel]) -> HourlyWeatherViewController
    func makeHourlyWeatherViewController(for city: String,
                                         weathers: AnyPublisher<[WeatherViewModel], Never>) -> HourlyWeatherViewController
}


public final class WeathersViewController: UICollectionViewController {

    // MARK: Section Definitions
    enum Section: Hashable {
        //        var id: UUID { UUID() }
        case loading
        case currentWeatherSection
        case hourlyWeatherSection
        case dailyWeatherSection([WeatherViewModel])
    }

    enum SupplementaryViewKind {
        static let hourlyWeatherHeader = "hourly"
        static let dailyWeatherHeader = "daily"
        //        static let bottomLine = "bottomLine"
    }

    // MARK: - Properties

    let viewModel: WeathersViewModel
    //    var formatter: WeartherFormatterProtocol

    private var subscriptions = Set<AnyCancellable>()
    private var presentHourlyWeatherSubscription: AnyCancellable?
    
    public var locationID: Int {
        viewModel.location.index
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    private var sections = [Section]()

        @Published private var currentWeatherItem: Item?
        @Published private var hourlyWeatherItems: [Item]?
    //    @Published private var dailyWeatherItems: [Item] = []

//    @Published private var currentWeatherSection: Section?
//    @Published private var hourlyWeatherSection: Section?
    @Published private var dailyWeatherSection: Section?

    // Factories
    private let viewControllerFactory: HourlyWeatherViewControllerFactory

    // MARK: - Views

    //    private let currentWeatherViewCell: CurrentWeatherViewCell = {
    //        let cell = CurrentWeatherViewCell()
    //        return cell
    //    }()

    //    private let hourlyWeatherHeaderView: WeatherSectionHeaderView = {
    //        let view = WeatherSectionHeaderView()
    //        return view
    //    }()
    //
    //    private let dailyWeatherHeaderView: WeatherSectionHeaderView = {
    //        let view = WeatherSectionHeaderView()
    //        return view
    //    }()

    // MARK: - LifeCicle

    init(viewModel: WeathersViewModel,
         viewControllerFactory: HourlyWeatherViewControllerFactory
         //         weatherFormatter: WeartherFormatterProtocol
    ) {

        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
        //        self.formatter = weatherFormatter

        super.init(nibName: nil, bundle: nil)

        //        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createBasicListLayout())
        ////        collectionView.collectionViewLayout = createBasicListLayout()
        //        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        //        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
        //                                              heightDimension: .fractionalHeight(1.0))
        //        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //
        //        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
        //                                               heightDimension: .absolute(44))
        //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
        //                                                       subitems: [item])
        //
        //        let section = NSCollectionLayoutSection(group: group)
        //
        //        let layout = UICollectionViewCompositionalLayout(section: section)
        //        super.init(collectionViewLayout: layout)

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

        //        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createBasicListLayout())
        //        collectionView.collectionViewLayout = createBasicListLayout()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false



        //        view.backgroundColor = .white

        // Do any additional setup after loading the view.




        //        let label = UILabel()
        //        label.text = viewModel.weatherLocation.cityName
        //        view.addSubview(label)
        //        view.bringSubviewToFront(label)
        //
        //        label.snp.makeConstraints { make in
        //            make.center.equalToSuperview()
        //        }
        //

        //        bindTextFieldsToViewModel()
        bindViewModelToViews()
        //        bindSettings()


        Task {
            await viewModel.fetchWeather()
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.brandTextColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
    }


    // MARK: - Metods

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        // Register cell classes

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
        //        collectionView.register(LineView.self, forSupplementaryViewOfKind:
        //                                    SupplementaryViewKind.topLine, withReuseIdentifier:
        //                                    LineView.reuseIdentifier)
        //        collectionView.register(LineView.self, forSupplementaryViewOfKind:
        //                                    SupplementaryViewKind.bottomLine, withReuseIdentifier:
        //                                    LineView.reuseIdentifier)

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = .init(top: 112, left: 0, bottom: 0, right: 0)
        //        collectionView.bounces = false
        //        collectionView.alwaysBounceHorizontal = false
        configureDataSource()
    }

//    private func createMainSection() -> NSCollectionLayoutSection {
//
//    }


    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard !self.sections.isEmpty else { return nil }

            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(44))
            let hourlyWeatherHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                                      elementKind: SupplementaryViewKind.hourlyWeatherHeader,
                                                                                      alignment: .topTrailing)

            let dailyWeatherHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                                     elementKind: SupplementaryViewKind.dailyWeatherHeader,
                                                                                     alignment: .topTrailing)

            //            let lineItemHeight = 1 / layoutEnvironment.traitCollection.displayScale
            //            let lineItemSize =
            //            NSCollectionLayoutSize(widthDimension:
            //                    .fractionalWidth(0.92),
            //                                   heightDimension: .absolute(lineItemHeight))
            //
            //            let topLineItem =
            //            NSCollectionLayoutBoundarySupplementaryItem(layoutSize:
            //                                                            lineItemSize, elementKind: SupplementaryViewKind.topLine,
            //                                                        alignment: .top)
            //
            //            let bottomLineItem =
            //            NSCollectionLayoutBoundarySupplementaryItem(layoutSize:
            //                                                            lineItemSize, elementKind: SupplementaryViewKind.bottomLine,
            //                                                        alignment: .bottom)

            //            let supplementaryItemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4,
            //                                                                         bottom: 0, trailing: 4)
            //            hourlyWeatherHeaderItem.contentInsets = supplementaryItemContentInsets
            //            dailyWeatherHeaderItem.contentInsets = supplementaryItemContentInsets
            //            topLineItem.contentInsets = supplementaryItemContentInsets
            //            bottomLineItem.contentInsets = supplementaryItemContentInsets

            let section = self.sections[sectionIndex]
            switch section {
                case .loading:
                    // MARK: Loading Section Layout
//                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                                          heightDimension: .fractionalHeight(1))
//
//                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
//                                                           heightDimension: .estimated(212))
//                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                                   subitems: [item])
//
//                    let section = NSCollectionLayoutSection(group: group)
//                    section.orthogonalScrollingBehavior = .groupPagingCentered
//
//                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0,
//                                                                    bottom: 8, trailing: 0)
//
//                    return section

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
                    //                    section.boundarySupplementaryItems = [topLineItem,
                    //                                                          bottomLineItem]

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
#warning("absolute")
                    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(42 + 16),
                                                           heightDimension: .estimated(84))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                   subitems: [item])

//                    group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8,
//                                                                  bottom: 0, trailing: 8)
#warning("Attempting to add contentInsets to an item's dimension along an estimated axis")

                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = [hourlyWeatherHeaderItem]
                    //                                                          bottomLineItem]

                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16,
                                                                    bottom: 32, trailing: 16)

                    return section

                case .dailyWeatherSection:
                    // MARK: Daily Weather Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalHeight(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    //                    let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
                    //                    let groupWidth = availableLayoutWidth * 0.92
                    //                    let remainingWidth = availableLayoutWidth - groupWidth
                    //                    let halfOfRemainingWidth = remainingWidth / 2.0
                    //                    let nonCategorySectionItemInset = CGFloat(4)
                    //                    let itemLeadingAndTrailingInset = halfOfRemainingWidth + nonCategorySectionItemInset

                    item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0,
                                                                 bottom: 8, trailing: 0)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .estimated(66))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                                 subitems: [item])
                    //                    group.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 0,
                    //                                                                  bottom: 0, trailing: 6)

                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16,
                                                                    bottom: 20, trailing: 16)

                    section.boundarySupplementaryItems = [dailyWeatherHeaderItem]

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
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherViewCell.identifier,
                                                                      for: indexPath)
                            as? CurrentWeatherViewCell,
                        case .currentWeatherItem(let currentWeather) = self.currentWeatherItem
                    else {
                        return nil
                    }

                    cell.setup(with: currentWeather)

                    return cell
                case .hourlyWeatherSection:

                    //                    print(indexPath)
                    guard
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherViewCell.identifier,
                                                                      for: indexPath)
                            as? HourlyWeatherViewCell,
                        case .hourlyWeatherItem(let hourlytWeathers) = self.hourlyWeatherItems?[indexPath.item]
                    else {
                        return nil
                    }

                    cell.setup(with: hourlytWeathers)

                    return cell
                case .dailyWeatherSection:
                    guard
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherViewCell.identifier,
                                                                      for: indexPath)
                            as? DailyWeatherViewCell,
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
                        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.hourlyWeatherHeader,
                                                                                         withReuseIdentifier: WeatherSectionHeaderView.identifier,
                                                                                         for: indexPath)
                            as? WeatherSectionHeaderView
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

                    //                    self.viewModel.subscribeToggleForecastHorizon(to: publisher)

                    return headerView

                    //                case SupplementaryViewKind.topLine, SupplementaryViewKind.bottomLine:
                    //                    let lineView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LineView.reuseIdentifier, for: indexPath) as! LineView
                    //                    return lineView
                case SupplementaryViewKind.dailyWeatherHeader:
                    guard
                        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.dailyWeatherHeader,
                                                                                         withReuseIdentifier: WeatherSectionHeaderView.identifier,
                                                                                         for: indexPath)
                            as? WeatherSectionHeaderView
                    else {
                        return nil
                    }

                    let publisher = headerView.buttonTappedPublisher.eraseType()
                    self.viewModel.subscribeToggleForecastHorizon(to: publisher)

                    let buttonTitle = "\(self.viewModel.toggleForecastHorizonTitle) дней"

                    headerView.setup(labelTitle: "Ежедневный прогноз", buttonTitle: buttonTitle)

                    return headerView

                default:
                    return nil
            }
        }



    }

    //    private func bindTextFieldsToViewModel()
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
                .map { Item.currentWeatherItem($0) }
                .assign(to: &$currentWeatherItem)

            viewModel
                .$hourlyWeather
                .removeDuplicates()
                .map { weathers in
                    weathers.map { Item.hourlyWeatherItem($0) }
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
                //                $currentWeatherItem.removeDuplicates().map { _ in }.eraseToAnyPublisher(),
                //                $hourlyWeatherItems.removeDuplicates().map { _ in }.eraseToAnyPublisher(),
                //                $dailyWeatherItems.removeDuplicates().map { _ in }.eraseToAnyPublisher()
                $currentWeatherItem.eraseTypeAndDuplicates(),
                $hourlyWeatherItems.eraseTypeAndDuplicates(),
                //                $dailyWeatherItems.eraseTypeAndDuplicates(),

//                $currentWeatherSection.eraseTypeAndDuplicates(),
//                $hourlyWeatherSection.eraseTypeAndDuplicates(),
                $dailyWeatherSection.eraseTypeAndDuplicates()
            )
            .debounce(for: .seconds(0.3), scheduler: RunLoop.current)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.applySnapshot()
            }
            .store(in: &subscriptions)
        }
        
        bindViewModelToErrors()
        bindViewModelToWeathers()
        bindToCollectionView()


    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        if currentWeatherItem == nil,
           hourlyWeatherItems == nil,
           dailyWeatherSection == nil {

            snapshot.appendSections([.loading])
            snapshot.appendItems([Item.empty(UUID())], toSection: .loading)
        }

        if let currentWeatherItem = currentWeatherItem,
           case .currentWeatherItem(let weather) = currentWeatherItem {
            snapshot.appendSections([.currentWeatherSection])

            let item = Item.currentWeatherItem(weather)
            snapshot.appendItems([item], toSection: .currentWeatherSection)
        }

        if let hourlyWeatherItems = hourlyWeatherItems {
            snapshot.appendSections([.hourlyWeatherSection])

            snapshot.appendItems(hourlyWeatherItems, toSection: .hourlyWeatherSection)
        }

        if let dailyWeatherSection = dailyWeatherSection,
           case .dailyWeatherSection(let weathers) = dailyWeatherSection {
            snapshot.appendSections([dailyWeatherSection])

            let items = weathers.map { Item.dailyWeatherItem($0) }
            snapshot.appendItems(items, toSection: dailyWeatherSection)
        }

        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }

    private func presentHourlyWeather() {
//        guard let hourlyWeatherItems = hourlyWeatherItems else { return }
//        let hourlyWeathers = hourlyWeatherItems.compactMap { item -> WeatherViewModel? in
//            if case let .hourlyWeatherItem(weather) = item {
//                return weather
//            } else {
//                return nil
//            }
//        }
        let hourlyWeatherPublisher = viewModel.$hourlyWeather.eraseToAnyPublisher()
        let hourlyViewController = viewControllerFactory.makeHourlyWeatherViewController(for: viewModel.location.cityName,
//                                                                                         weathers: hourlyWeathers)
                                                                                         weathers: hourlyWeatherPublisher)
        
        navigationController?.pushViewController(hourlyViewController, animated: true)
    }




    // MARK: UICollectionViewDataSource

    //    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    //
    //
    //    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of items
    //        return 1
    //    }
    //
    //    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    //
    //        // Configure the cell
    //
    //        return cell
    //    }

    // MARK: UICollectionViewDelegate

    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        presentHourlyWeather()
    }

    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */

    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */

    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }

     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }

     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

     }
     */

}
