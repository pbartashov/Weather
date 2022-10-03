//
//  Publisher+.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 04.10.2022.
//

import Combine

extension Publisher where Output: Equatable {
    func eraseTypeAndDuplicates() -> AnyPublisher<Void, Self.Failure> {
        self.removeDuplicates()
        .map { _ in }
        .eraseToAnyPublisher()
    }
}
