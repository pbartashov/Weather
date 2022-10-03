//
//  MainViewController.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit
import WeatherKit
import Combine

public final class WeathersViewController: UICollectionViewController {

    // MARK: Section Definitions
    enum Section: Hashable {
        case currentWeatherSection
        case hourlyWeatherSection
        case dailyWeatherSection
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
    
    public var locationID: Int {
        viewModel.location.index
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    private var sections = [Section]()

    @Published private var currentWeatherItem: Item?
    @Published private var hourlyWeatherItems: [Item] = []
    @Published private var dailyWeatherItems: [Item] = []



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

    init(viewModel: WeathersViewModel
         //         weatherFormatter: WeartherFormatterProtocol
    ) {

        self.viewModel = viewModel
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




    // MARK: - Metods

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        // Register cell classes
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

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard !self.sections.isEmpty else { return nil }

            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                                                        heightDimension: .estimated(44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                         elementKind: SupplementaryViewKind.hourlyWeatherHeader,
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

            let supplementaryItemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4,
                                                                         bottom: 0, trailing: 4)
            headerItem.contentInsets = supplementaryItemContentInsets
//            topLineItem.contentInsets = supplementaryItemContentInsets
//            bottomLineItem.contentInsets = supplementaryItemContentInsets

            let section = self.sections[sectionIndex]
            switch section {
                case .currentWeatherSection:
                    // MARK: Promoted Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalHeight(1))

                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4,
//                                                                 bottom: 0, trailing: 4)
#warning("absolute")
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                                                           heightDimension: .estimated(212))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                   subitems: [item])

                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .groupPagingCentered
//                    section.boundarySupplementaryItems = [topLineItem,
//                                                          bottomLineItem]

                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0,
                                                                    bottom: 20, trailing: 0)

                    return section

                case .hourlyWeatherSection:
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

                    group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8,
                                                                 bottom: 0, trailing: 8)

                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = [headerItem]
//                                                          bottomLineItem]

                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16,
                                                                    bottom: 24, trailing: 16)

                    return section

                case .dailyWeatherSection:
                    // MARK: Categories Section Layout
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

                    section.boundarySupplementaryItems = [headerItem]

                    return section
            }
        }

        return layout
    }

    func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { [weak self]
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let section = self.sections[indexPath.section]
            switch section {
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
                        case .hourlyWeatherItem(let hourlytWeather) = self.hourlyWeatherItems[indexPath.item]
                    else {
                        return nil
                    }

                    cell.setup(with: hourlytWeather)

                    return cell
                case .dailyWeatherSection:
                    guard
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherViewCell.identifier,
                                                                      for: indexPath)
                            as? DailyWeatherViewCell,
                        case .dailyWeatherItem(let dailyWeather) = self.dailyWeatherItems[indexPath.item]
                    else {
                        return nil
                    }

                    cell.setup(with: dailyWeather)

                    return cell

            }
        })

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
                case SupplementaryViewKind.hourlyWeatherHeader:
//                    let section = self.sections[indexPath.section]
//                    let sectionName: String
//                    switch section {
//                        case .currentWeatherSection:
//                            return nil
//                        case .hourlyWeatherSection(let name):
//                            sectionName = name
//                        case .dailyWeatherSection:
                    //                            sectionName = "Top Categories"
                    //                    }
                    guard
                        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.hourlyWeatherHeader,
                                                                                         withReuseIdentifier: WeatherSectionHeaderView.identifier,
                                                                                         for: indexPath)
                            as? WeatherSectionHeaderView
                    else {
                        return nil
                    }

//                    headerView.setup(with: self.viewModel.currentWeather!)

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

                    //                    headerView.setup(with: self.viewModel.currentWeather!)

                    return headerView

                default:
                    return nil
            }
        }


//        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
//        snapshot.appendSections([.promoted])
//
//        guard let current = self.viewModel.currentWeather else { return }
//        let currentWeather = Item.currentWeatherItem(current)
//        snapshot.appendItems([currentWeather], toSection: .promoted)
//
//        let popularSection = Section.standard("Popular this week")
//        let essentialSection = Section.standard("Essential picks")
//        let categoriesSection = Section.categories
//
//        let weathers = self.viewModel.hourlyWeather.map { Item.hourlyWeatherItem($0)}
//        snapshot.appendSections([popularSection, categoriesSection])
//        snapshot.appendItems(weathers, toSection: popularSection)
////        snapshot.appendItems(Item.essentialApps, toSection: essentialSection)
//        snapshot.appendItems(weathers, toSection: categoriesSection)
//
//        sections = snapshot.sectionIdentifiers
//        dataSource.apply(snapshot)

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
//                .zip(viewModel.$hourlyWeather)//, viewModel.$dailyWeather)
                .compactMap { $0 }
                .map { Item.currentWeatherItem($0) }
//                .receive(on: DispatchQueue.main)
//                .sink { currentWeather in
//
//
//                    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
////                    if let currentWeather = currentWeather {
//                        snapshot.appendSections([.currentWeatherSection])
//                        snapshot.appendItems([.currentWeatherItem(currentWeather)], toSection: .currentWeatherSection)
////                    }
//
//
//                    «let popularSection = Section.standard("Popular this week")
//                    let essentialSection = Section.standard("Essential picks")
//
//                    snapshot.appendSections([.hourWeatherSection])
//                    snapshot.appendItems(Item.popularApps, toSection: .hourWeatherSection)
//                    snapshot.appendItems(Item.essentialApps, toSection: essentialSection)
//
//
//                    self.sections = snapshot.sectionIdentifiers
//
//                    self.dataSource.apply(snapshot)
//
//
//                }
//                .store(in: &subscriptions)
                .assign(to: &$currentWeatherItem)

            viewModel
                .$hourlyWeather
                .removeDuplicates()
                .map { weathers in
                    weathers.map {
                        Item.hourlyWeatherItem($0)
                    }
                }
                .assign(to: &$hourlyWeatherItems)

            viewModel
                .$dailyWeather
                .removeDuplicates()
                .map { weathers in
                    weathers.map {
                        Item.dailyWeatherItem($0)
                    }
                }
                .assign(to: &$dailyWeatherItems)
        }
//
        func bindToCollectionView() {
            Publishers.MergeMany(
//                $currentWeatherItem.removeDuplicates().map { _ in }.eraseToAnyPublisher(),
//                $hourlyWeatherItems.removeDuplicates().map { _ in }.eraseToAnyPublisher(),
//                $dailyWeatherItems.removeDuplicates().map { _ in }.eraseToAnyPublisher()
                $currentWeatherItem.eraseTypeAndDuplicates(),
                $hourlyWeatherItems.eraseTypeAndDuplicates(),
                $dailyWeatherItems.eraseTypeAndDuplicates()

            )
            .debounce(for: .seconds(0.1), scheduler: RunLoop.current)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                //                    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
//
////                    if case .currentWeatherItem(let currentWeather) = self.currentWeatherItem {
////                    if let currentWeatherItem = self.currentWeatherItem {
////                        snapshot.appendSections([.currentWeatherSection])
////                        snapshot.appendItems([currentWeatherItem], toSection: .currentWeatherSection)
////                    }
//
////                    if case .hourlyWeatherItem(let hourlyWeathers) = self.hourlyWeatherItem {
////                        snapshot.appendSections([.hourlyWeatherSection])
////                    snapshot.appendItems(self.hourlyWeatherItems, toSection: .hourlyWeatherSection)
////                    }
//
//
//                    //                    snapshot.appendSections([.hourWeatherSection])
//                    //                    snapshot.appendItems(Item.popularApps, toSection: .hourWeatherSection)
//                    //                    snapshot.appendItems(Item.essentialApps, toSection: essentialSection)
//
//                    self.sections = snapshot.sectionIdentifiers
//
//                    self.dataSource.apply(snapshot)

                    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()


                    if let currentWeatherItem = self.currentWeatherItem {
                        snapshot.appendSections([.currentWeatherSection])
                        snapshot.appendItems([currentWeatherItem], toSection: .currentWeatherSection)
                    }


//                    let popularSection = Section.hourlyWeatherSection("Popular this week")
//                    let essentialSection = Section.hourlyWeatherSection("Essential picks")
//                    let categoriesSection = Section.dailyWeatherSection


//                    let weathers = self.viewModel.hourlyWeather.map { Item.hourlyWeatherItem($0)}
//                    let weathers2 = Array(weathers.prefix(10))
                    snapshot.appendSections([.hourlyWeatherSection, .dailyWeatherSection])
                    snapshot.appendItems(self.hourlyWeatherItems, toSection: .hourlyWeatherSection)
                    snapshot.appendItems(self.dailyWeatherItems, toSection: .dailyWeatherSection)

                    self.sections = snapshot.sectionIdentifiers
                    self.dataSource.apply(snapshot)
                }
                .store(in: &subscriptions)
        }
        
        bindViewModelToErrors()
        bindViewModelToWeathers()
        bindToCollectionView()


    }

//    private func bindSettings() {
//        let settings = Settings.shared
//
//        Publishers.MergeMany(
//            settings.$temperature.removeDuplicates().map({ _ in }).eraseToAnyPublisher(),
//            settings.$speed.removeDuplicates().map({ _ in }).eraseToAnyPublisher(),
//            settings.$timeFormat.removeDuplicates().map({ _ in }).eraseToAnyPublisher(),
//            settings.$notificationsState.removeDuplicates().map({ _ in }).eraseToAnyPublisher()
//        )
//        .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
//        .receive(on: DispatchQueue.main)
//        .sink { [weak self] _ in
//            print("collectionView.reloadData")
//
//
//
//            self?.collectionView.reloadData()
//
//        }
//        .store(in: &subscriptions)
//
//
//        //            .merge(with: settings.$speed)
//        //            .sink { [weak self] in
//        //                                self?.collectionView.reloadData()
//        //                            }
//        //                            .store(in: &subscriptions)
//
//        //            .eraseToAnyPublisher()
//        //            .merge(settings.$speed.eraseToAnyPublisher(), settings.$timeFormat.eraseToAnyPublisher(), settings.$notificationsState.eraseToAnyPublisher())
//        //            .sink { [weak self] in
//        //                self?.collectionView.reloadData()
//        //            }
//        //            .store(in: &subscriptions)
//    }




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
