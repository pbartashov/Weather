//
//  SearchLocationDependencyContainer.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 18.10.2022.
//

import WeatherKit

public final class SearchLocationDependencyContainer {

    // MARK: - Properties

    private let searchLocationResponder: SearchLocationResponder

    // MARK: - LifeCicle
    init(searchLocationResponder: SearchLocationResponder) {
        self.searchLocationResponder = searchLocationResponder
    }

    // MARK: - Metods

    public func makeSearchLocationViewController() -> SearchLocationViewController {
        let viewModel = makeSearchLocationViewModel()
        return SearchLocationViewController(viewModel: viewModel,
                                            searchLocationResponder: searchLocationResponder)
    }

    func makeSearchLocationViewModel() -> SearchLocationViewModel {
        SearchLocationViewModel()
    }
}
