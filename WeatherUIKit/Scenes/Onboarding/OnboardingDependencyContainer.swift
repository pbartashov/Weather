//
//  OnboardingDependencyContainer.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 18.10.2022.
//

import WeatherKit

public final class OnboardingDependencyContainer {

    // MARK: - Properties

    private let onboardingResponder: OnboardingResponder

    // MARK: - Views

    // MARK: - LifeCicle
    init(onboardingResponder: OnboardingResponder) {
        self.onboardingResponder = onboardingResponder
    }

    // MARK: - Metods

    public func makeOnboardingViewController() -> OnboardingViewController {
        let viewModel = makeOnboardingViewModel()
        return OnboardingViewController(viewModel: viewModel,
                                        onboardingResponder: onboardingResponder)
    }

    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel()
    }
}
