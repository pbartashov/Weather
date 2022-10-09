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
            .eraseType()
    }

    func eraseType() -> AnyPublisher<Void, Self.Failure> {
        self.map { _ in }
            .eraseToAnyPublisher()
    }
}
