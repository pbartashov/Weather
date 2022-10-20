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

    // MARK: Section Definitions

    private enum Section: Hashable {
        case addresses
    }

    private enum Cell: Hashable {
        case address(LocationAddress)
    }

    // MARK: - Properties

    private let viewModel: SearchLocationViewModel
    private let searchLocationResponder: SearchLocationResponder

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

    // MARK: - LifeCicle

    public init(
        viewModel: SearchLocationViewModel,
        searchLocationResponder: SearchLocationResponder
    ) {
        self.viewModel = viewModel
        self.searchLocationResponder = searchLocationResponder

        super.init(nibName: nil, bundle: nil)

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

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar

        self.searchController = searchController
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

    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
           !searchText.isEmpty {
            viewModel.fetch(locality: searchText)
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

