//
//  SearchLocationViewController.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 15.10.2022.
//

import UIKit
import WeatherKit
import Combine

public class SearchLocationViewController: UITableViewController, UISearchResultsUpdating {
    //    private var tableView: UITableView: UITableView = {
    //        let tableView = UITableView()
    //        tableView.regi
    //    }()

    private enum Section: Hashable {
        case addresses
    }

    private enum Cell: Hashable {
        case address(LocationAddress)
    }

    // MARK: - Properties

    private let viewModel: SearchLocationViewModel
    private let searchLocationResponder: SearchLocationResponder

    //

//    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
//                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
//                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
//                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
//                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
//
//    var filteredData: [String]!
    private var subscriptions = Set<AnyCancellable>()


    private lazy var dataSource: UITableViewDiffableDataSource<Section, Cell> = {
        let tableViewDataSource = UITableViewDiffableDataSource<Section, Cell>(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, cell) -> UITableViewCell? in
                guard
                    let self = self,
                    let tableCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier),
                    case let .address(address) = cell
                else {
                    return UITableViewCell()
                }
//                let address = self.viewModel.addresses[indexPath.row]
                var content = tableCell.defaultContentConfiguration()

                content.text = address.city
                content.secondaryText = address.country
                tableCell.contentConfiguration = content

                return tableCell
            })

        return tableViewDataSource
    }()

    private var snapshot: NSDiffableDataSourceSnapshot<Section, Cell> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cell>()
        snapshot.appendSections([.addresses])
        let cells = viewModel.addresses.map {
            Cell.address($0)
        }
        snapshot.appendItems(cells, toSection: .addresses)

        return snapshot
    }
    // MARK: - Views

    

    private var searchController: UISearchController?
//    private var searchBar: UISearchBar!

    // MARK: - LifeCicle

    public init(
        viewModel: SearchLocationViewModel,
        searchLocationResponder: SearchLocationResponder
    ) {
        self.viewModel = viewModel
        self.searchLocationResponder = searchLocationResponder

        //            super.init(searchResultsController: UIViewController())
        super.init(nibName: nil, bundle: nil)


        //        modalTransitionStyle = .partialCurl
        //            modalPresentationStyle = .formSheet//UIModalPresentationFormSheet
        //        initialize()


        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

        viewModel.fetchCurrentLocality()
    }

    // MARK: - Metods

    private func initialize() {
        tableView.dataSource = self
        //        filteredData = data

        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar

        self.searchController = searchController
//        self.searchBar = searchController.searchBar
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true

        bindToViewModel()
    }

    private func bindToViewModel() {
        func bindViewModelToErrors() {
            viewModel.errorMessages
                .receive(on: DispatchQueue.main)
                .sink { error in
                    ErrorPresenter.shared.show(error: error)
                }
                .store(in: &subscriptions)
        }

        func bindViewModelToSearchText() {
            guard let searchBar = searchController?.searchBar else { return }
            viewModel.$searchText
                .receive(on: DispatchQueue.main)
                .assign(to: \.text, on: searchBar)
                .store(in: &subscriptions)
        }

        func bindViewModelToAddresses() {
            viewModel.$addresses
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.applySnapshot()
                }
                .store(in: &subscriptions)
        }

        bindViewModelToErrors()
        bindViewModelToSearchText()
        bindViewModelToAddresses()
    }
    
//    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier) else {
//            return UITableViewCell()
//        }
//        let address = viewModel.addresses[indexPath.row]
//        var content = cell.defaultContentConfiguration()
//
//        content.text = address.city
//        content.secondaryText = address.country
//        cell.contentConfiguration = content
//
//        return cell
//    }
//
//    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.addresses.count
//    }

    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
           !searchText.isEmpty {
//            filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
//                return dataString.range(of: searchText, options: .caseInsensitive) != nil
//            })
            viewModel.fetch(locality: searchText)
//            tableView.reloadData()
        }
    }

    private func applySnapshot() {
        if view.window != nil {
            dataSource.apply(snapshot)
        }
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = viewModel.addresses[indexPath.row]
        searchLocationResponder.selected(address: address)
    }
}

//
//
//public final class SearchLocationViewController: UISearchController {
//    // MARK: - Properties
//    private let searchLocationResponder: SearchLocationResponder
//
//
//    // Factories
//    //    let makeWeatherViewController: (Int) -> WeathersViewController
//    //    let makeSettingsViewController: () -> SettingsViewController
//
//
//    // MARK: - Views
//    //
//    //    private lazy var addButton: UIButton = {
//    //        let button = UIButton()
//    //
//    //        button.titleLabel?.font = .systemFont(ofSize: 150, weight: .bold)
//    //        button.setTitle("+", for: .normal)
//    //        button.setTitleColor(.brandTextColor, for: .normal)
//    //
//    ////        button.addTarget(addLocationResponder,
//    ////                         action: #selector(AddLocationResponder.handleAddLocation),
//    ////                         for: .touchUpInside)
//    //
//    //        return button
//    //    }()
//
//    private var searchTextField: UITextField?
//
//    @Published var searchText: String? = nil {
//        didSet {
//            searchTextField?.text = searchText
//        }
//    }
//
//
//
//    // MARK: - LifeCicle
//
//    //    init() {
//    //        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
//    //    }
//
//    public init(
//        searchLocationResponder: SearchLocationResponder
//    ) {
//        self.searchLocationResponder = searchLocationResponder
//
//        super.init(searchResultsController: UIViewController())
////        super.init(nibName: nil, bundle: nil)
//
//
////        modalTransitionStyle = .partialCurl
//        modalPresentationStyle = .formSheet//UIModalPresentationFormSheet
////        initialize()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//
//    }
//
//
//
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//
//
//
//
//    // MARK: - Metods
//
//    private func initialize() {
////        addTextField { textField in
////            //            if let text = text {
////            //                textField.text = text
////            //            } else {
////            //                textField.placeholder = "Имя автора"
////            //            }
////
////            self.searchTextField = textField
////        }
//
////        let search = UIAlertAction(title: "Искать", style: .default) { [weak self] _ in
////            if let self = self,
////               let searchText = self.searchTextField?.text,
////               !searchText.isEmpty {
////                self.searchText = searchText
////            }
////        }
////        addAction(search)
////
////        let cancel = UIAlertAction(title: "Отменить", style: .default) { _ in
////            //            cancelComletion?()
////        }
////        addAction(cancel)
//
//    }
//}



//public final class SearchLocationViewController: UIAlertController {
//
//
//    // MARK: - Properties
//
//    //    private let viewModel: MainViewModel
//    private let searchLocationResponder: SearchLocationResponder
//
//
//    // Factories
//    //    let makeWeatherViewController: (Int) -> WeathersViewController
//    //    let makeSettingsViewController: () -> SettingsViewController
//
//
//    // MARK: - Views
////
////    private lazy var addButton: UIButton = {
////        let button = UIButton()
////
////        button.titleLabel?.font = .systemFont(ofSize: 150, weight: .bold)
////        button.setTitle("+", for: .normal)
////        button.setTitleColor(.brandTextColor, for: .normal)
////
//////        button.addTarget(addLocationResponder,
//////                         action: #selector(AddLocationResponder.handleAddLocation),
//////                         for: .touchUpInside)
////
////        return button
////    }()
//
//    private var searchTextField: UITextField?
//
//    @Published var searchText: String? = nil {
//        didSet {
//            searchTextField?.text = searchText
//        }
//    }
//
//
//
//    // MARK: - LifeCicle
//
//    //    init() {
//    //        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
//    //    }
//
//    public init(
//        title: String,
//        message: String? = nil,
//        searchLocationResponder: SearchLocationResponder
//    ) {
//        self.searchLocationResponder = searchLocationResponder
//
//        super.init(title: title,
//                          message: message,
//                          preferredStyle: .alert)
//
//        initialize()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//
//    }
//
//
//
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//
//
//
//
//
//    }
//
//
//
//
//
//    // MARK: - Metods
//
//    private func initialize() {
//        addTextField { textField in
////            if let text = text {
////                textField.text = text
////            } else {
////                textField.placeholder = "Имя автора"
////            }
//
//            self.searchTextField = textField
//        }
//
//        let search = UIAlertAction(title: "Искать", style: .default) { [weak self] _ in
//            if let self = self,
//               let searchText = self.searchTextField?.text,
//               !searchText.isEmpty {
//                self.searchText = searchText
//            }
//        }
//        addAction(search)
//
//        let cancel = UIAlertAction(title: "Отменить", style: .default) { _ in
////            cancelComletion?()
//        }
//        addAction(cancel)
//
//    }
//
////    private func setupLayout() {
////        addButton.snp.makeConstraints { make in
////            make.center.equalToSuperview()
////        }
////
////    }
//    //
//    //    @objc private func addButtonTapped() {
//    //
//    //    }
//
//
//
//}
//
//
