//
//  ViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 13.10.2022.
//

import Combine

public class ViewModel {
    public var errorMessages: AnyPublisher<Error, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }

    let errorMessagesSubject = PassthroughSubject<Error, Never>()

    var subscriptions = Set<AnyCancellable>()
}
