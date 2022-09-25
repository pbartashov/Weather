//
//  MainViewController.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit
import WeatherKit
import Combine

public final class WeatherViewController: UICollectionViewController {

    // MARK: Section Definitions
    enum Section: Hashable {
        case currentWeather
        case hourWeather
        case dayWeather
    }

    // MARK: - Properties

    let viewModel: WeatherViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    public var locationID: Int {
        viewModel.location.index
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    var sections = [Section]()


    // MARK: - Views

    // MARK: - LifeCicle

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
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



        view.backgroundColor = .yellow

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


        Task {
            await viewModel.fetchWeather()
        }
    }




    // MARK: - Metods

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout
        { [weak self] (sectionIndex, layoutEnvironment) ->
            NSCollectionLayoutSection? in
            guard let self = self,
                  !self.sections.isEmpty else { return nil }

            let section = self.sections[sectionIndex]
            switch section {
                case .currentWeather:
                    // MARK: Promoted Section Layout
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalWidth(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                                                           heightDimension: .estimated(300))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                   subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)

                    return section

                default:
                    return nil
            }
        }
        return layout
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        // Register cell classes
        collectionView.register(CurrentWeatherViewCell.self,
                                forCellWithReuseIdentifier: CurrentWeatherViewCell.identifier)

        configureDataSource()
    }

    private func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView, cellProvider: {
            [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let section = self.sections[indexPath.section]
            switch section {
                case .currentWeather:
                    guard
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherViewCell.identifier,
                                                                      for: indexPath)
                            as? CurrentWeatherViewCell,
                        let currentWeather = self.viewModel.currentWeather
                    else {
                        return nil
                    }

                    cell.setup(with: currentWeather)

                    return cell

                default:
                    fatalError("Not yet implemented.")
            }
        })



        // MARK: Snapshot Definition
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        if let currentWeather = self.viewModel.currentWeather {
            snapshot.appendSections([.currentWeather])
            snapshot.appendItems([.currentWeather(currentWeather)], toSection: .currentWeather)
        }

        sections = snapshot.sectionIdentifiers

        dataSource.apply(snapshot)
    }

//    private func bindTextFieldsToViewModel()
    private func bindViewModelToViews() {
        func bindViewModelToCurrentWeather() {
            viewModel
                .$currentWeather
                .receive(on: DispatchQueue.main)
                .sink { _ in


                    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                    if let currentWeather = self.viewModel.currentWeather {
                        snapshot.appendSections([.currentWeather])
                        snapshot.appendItems([.currentWeather(currentWeather)], toSection: .currentWeather)
                    }

                    self.sections = snapshot.sectionIdentifiers

                    self.dataSource.apply(snapshot)


                }
                .store(in: &subscriptions)
        }

        bindViewModelToCurrentWeather()


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
