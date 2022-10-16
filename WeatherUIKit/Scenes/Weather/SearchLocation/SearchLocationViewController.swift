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
    private let searchLocationResponder: SearchLocationResponder
    //

    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]

    var filteredData: [String]!

    var searchController: UISearchController!

    public init(
            searchLocationResponder: SearchLocationResponder
        ) {
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

        tableView.dataSource = self
        filteredData = data

        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false

        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar

        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier)!
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
                return dataString.range(of: searchText, options: .caseInsensitive) != nil
            })

            tableView.reloadData()
        }
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
