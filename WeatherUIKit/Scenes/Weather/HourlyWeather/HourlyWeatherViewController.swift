//
//  HourlyWeatherViewController.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit
import WeatherKit
import Combine

public final class HourlyWeatherViewController: UICollectionViewController {

    // MARK: Section Definitions
    enum Section: Hashable {
        case chartSection
        case hourlyWeatherSection
    }

    enum SupplementaryViewKind {
        static let chartHeader = "chart"
        static let hourlyWeatherHeader = "hourlyWeatherHeader"
    }

    // MARK: - Properties

    let viewModel: HourlyWeatherViewModel

    private var subscriptions = Set<AnyCancellable>()

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    private var sections = [Section]()


    // MARK: - Views


    // MARK: - LifeCicle

    init(viewModel: HourlyWeatherViewModel) {

        self.viewModel = viewModel

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

        initialize()

        applySnapshot()
    }




    // MARK: - Metods

    private func initialize() {
        navigationController?.navigationBar.tintColor = .brandTextColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.brandTextGrayColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]

        title = "Прогноз на 24 часа"

        bindViewModelToViews()
    }

    private func bindViewModelToViews() {
        viewModel.$weathers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("🌴")

                //                self?.applySnapshot()
//                DispatchQueue.main.async {
                    self?.applySnapshot()
//                }
//                self?.collectionView.reloadData()
            }
            .store(in: &subscriptions)

    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        // Register cell classes

        collectionView.register(ChartViewCell.self,
                                forCellWithReuseIdentifier: ChartViewCell.identifier)

        collectionView.register(HourlyWeatherDetailedViewCell.self,
                                forCellWithReuseIdentifier: HourlyWeatherDetailedViewCell.identifier)

        collectionView.register(ChartSectionHeaderView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKind.chartHeader,
                                withReuseIdentifier: ChartSectionHeaderView.identifier)

        collectionView.register(LineView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKind.hourlyWeatherHeader,
                                withReuseIdentifier: LineView.identifier)

//        collectionView.contentInsetAdjustmentBehavior = .never
//        collectionView.contentInset = .init(top: 88, left: 0, bottom: 0, right: 0)

        configureDataSource()
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard !self.sections.isEmpty else { return nil }

            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(22))
            let chartHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                                      elementKind: SupplementaryViewKind.chartHeader,
                                                                                      alignment: .topLeading)

            chartHeaderItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 48,
                                                                    bottom: 0, trailing: 0)
//
            let hourlyWeatherHeaderItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .estimated(5))

            let hourlyWeatherHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hourlyWeatherHeaderItemSize,
                                                                             elementKind: SupplementaryViewKind.hourlyWeatherHeader,
                                                                             alignment: .top)

//            let supplementaryItemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4,
//                                                                         bottom: 0, trailing: 4)
//            headerItem.contentInsets = supplementaryItemContentInsets
//            topLineItem.contentInsets = supplementaryItemContentInsets
//            bottomLineItem.contentInsets = supplementaryItemContentInsets

            let section = self.sections[sectionIndex]
            switch section {
                case .chartSection:
                    // MARK: Chart Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(3),
                                                          heightDimension: .fractionalHeight(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8,
//                                                                 bottom: 0, trailing: 8)
#warning("absolute")
                    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1),
                                                           heightDimension: .estimated(152))

                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                   subitems: [item])

//                    group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 8,
//                                                                  bottom: 0, trailing: 8)

                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = [chartHeaderItem]
                    //                                                          bottomLineItem]

                    section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0,
                                                                    bottom: 20, trailing: 0)

                    return section

                case .hourlyWeatherSection:
                    // MARK: Daily Weather Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalHeight(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

//                    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0,
//                                                                 bottom: 0, trailing: 0)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .estimated(145))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                                 subitems: [item])
//                    group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8,
//                                                                  bottom: 0, trailing: 8)

                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0,
                                                                    bottom: 20, trailing: 0)

                    section.boundarySupplementaryItems = [hourlyWeatherHeaderItem]

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
                case .chartSection:
                    guard
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartViewCell.identifier,
                                                                      for: indexPath)
                            as? ChartViewCell
                    else {
                        return nil
                    }

                    self.setup(cell: cell)
//                    cell.setNeedsDisplay()
//                    cell.setNeedsLayout()

                    return cell

                case .hourlyWeatherSection:

                    //                    print(indexPath)
                    guard
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherDetailedViewCell.identifier,
                                                                      for: indexPath)
                            as? HourlyWeatherDetailedViewCell
                    else {
                        return nil
                    }

                    cell.setup(with: self.viewModel.weathers[indexPath.item])

                    return cell
            }
        })

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let self = self else { return nil }
            switch kind {
                case SupplementaryViewKind.chartHeader:
                    guard
                        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.chartHeader,
                                                                                         withReuseIdentifier: ChartSectionHeaderView.identifier,
                                                                                         for: indexPath)
                            as? ChartSectionHeaderView
                    else {
                        return nil
                    }

                    headerView.setup(labelTitle: self.viewModel.cityName)
//                    presentHourlyWeatherSubscription = headerView
//                        .buttonTappedPublisher
//                        .eraseType()
//                        .sink {[weak self] in
//                            self?.presentHourlyWeather()
//                        }

                    //                    self.viewModel.subscribeToggleForecastHorizon(to: publisher)

                    return headerView

                case SupplementaryViewKind.hourlyWeatherHeader:
                    guard
                        let lineView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                       withReuseIdentifier: LineView.identifier,
                                                                                       for: indexPath)
                            as? LineView else {
                        return nil
                    }

                    lineView.setColor(.brandLightGray)

                    return lineView

                default:
                    return nil
            }
        }



    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        snapshot.appendSections([.chartSection])
        snapshot.appendItems([Item.empty(UUID())], toSection: .chartSection)

        snapshot.appendSections([.hourlyWeatherSection])


        let items = viewModel.weathers.map { Item.hourlyWeatherItem($0) }
        snapshot.appendItems(items, toSection: .hourlyWeatherSection)



        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }

    private func setup(cell: ChartViewCell) {
//        print("🌴🌴")
        let weathers = viewModel.weathers.enumerated().compactMap { (i, weather) in
            i.isMultiple(of: 3) ? weather : nil
        }

        let temperatures = weathers.map { $0.tempValue }
        let temperaturesTexts = weathers.map { $0.temp }
        let images = weathers.map { $0.icon.icon }
        let precipcover = weathers.map { $0.precipcover }
        let times = weathers.map { $0.time }

        cell.setup(chartData: temperatures,
                   chartDataLabels: temperaturesTexts,
                   infoImages: images,
                   infoTexts: precipcover,
                   labelTexts: times)

//        print("🌴🌴🌴\(temperatures.count)")
    }



}