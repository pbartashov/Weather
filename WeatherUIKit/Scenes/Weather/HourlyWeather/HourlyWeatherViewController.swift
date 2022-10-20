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

    private let viewModel: HourlyWeatherViewModel

    private var subscriptions = Set<AnyCancellable>()

    private var dataSource: UICollectionViewDiffableDataSource<Section, WeatherCollectionItem>!
    private var sections = [Section]()

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
                self?.applySnapshot()
            }
            .store(in: &subscriptions)
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        collectionView.register(ChartViewCell.self,
                                forCellWithReuseIdentifier: ChartViewCell.identifier)

        collectionView.register(HourlyWeatherDetailedViewCell.self,
                                forCellWithReuseIdentifier: HourlyWeatherDetailedViewCell.identifier)

        collectionView.register(ChartSectionHeaderView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKind.chartHeader,
                                withReuseIdentifier: ChartSectionHeaderView.identifier)

        collectionView.register(LineReusableView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKind.hourlyWeatherHeader,
                                withReuseIdentifier: LineReusableView.identifier)

        configureDataSource()
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard !self.sections.isEmpty else { return nil }

            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(22))
            let chartHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: SupplementaryViewKind.chartHeader,
                alignment: .topLeading
            )
            chartHeaderItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 48,
                                                                    bottom: 0, trailing: 0)

            let hourlyWeatherHeaderItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                     heightDimension: .estimated(5))

            let hourlyWeatherHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: hourlyWeatherHeaderItemSize,
                elementKind: SupplementaryViewKind.hourlyWeatherHeader,
                alignment: .top
            )

            let section = self.sections[sectionIndex]
            switch section {
                case .chartSection:
                    // MARK: Chart Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(3),
                                                          heightDimension: .fractionalHeight(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1),
                                                           heightDimension: .estimated(152))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                   subitems: [item])

                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = [chartHeaderItem]
                    section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0,
                                                                    bottom: 20, trailing: 0)
                    return section

                case .hourlyWeatherSection:
                    // MARK: Daily Weather Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalHeight(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .estimated(145))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                                 subitems: [item])

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
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ChartViewCell.identifier,
                            for: indexPath
                        ) as? ChartViewCell
                    else {
                        return nil
                    }
                    self.setup(cell: cell)

                    return cell

                case .hourlyWeatherSection:
                    guard
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: HourlyWeatherDetailedViewCell.identifier,
                            for: indexPath
                        ) as? HourlyWeatherDetailedViewCell
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
                        let headerView = collectionView.dequeueReusableSupplementaryView(
                            ofKind: SupplementaryViewKind.chartHeader,
                            withReuseIdentifier: ChartSectionHeaderView.identifier,
                            for: indexPath
                        ) as? ChartSectionHeaderView
                    else {
                        return nil
                    }

                    headerView.setup(labelTitle: self.viewModel.cityName)

                    return headerView

                case SupplementaryViewKind.hourlyWeatherHeader:
                    guard
                        let lineView = collectionView.dequeueReusableSupplementaryView(
                            ofKind: kind,
                            withReuseIdentifier: LineReusableView.identifier,
                            for: indexPath
                        ) as? LineReusableView
                    else {
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherCollectionItem>()

        snapshot.appendSections([.chartSection])
        snapshot.appendItems([WeatherCollectionItem.empty(UUID())], toSection: .chartSection)

        snapshot.appendSections([.hourlyWeatherSection])
        let items = viewModel.weathers.map { WeatherCollectionItem.hourlyWeatherItem($0) }
        snapshot.appendItems(items, toSection: .hourlyWeatherSection)

        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }

    private func setup(cell: ChartViewCell) {
        let weathers = viewModel.weathers.enumerated().compactMap { (i, weather) in
            i.isMultiple(of: 3) ? weather : nil
        }

        let temperatures = weathers.map { $0.tempValue }
        let temperaturesTexts = weathers.map { $0.temp }
        let images = weathers.map { $0.icon.icon }
        let precipprob = weathers.map { $0.precipprob }
        let times = weathers.map { $0.timeDigitsOnly }

        cell.setup(chartData: temperatures,
                   chartDataLabels: temperaturesTexts,
                   infoImages: images,
                   infoTexts: precipprob,
                   labelTexts: times)
    }
}
