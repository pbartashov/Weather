//
//  OnboardingViewController.swift
//  Weather
//
//  Created by Павел Барташов on 15.09.2022.
//

import UIKit
import WeatherKit

public final class OnboardingViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: OnboardingViewModel
    private let onboardingView: OnboardingView

    // MARK: - LifeCicle

    public init(
        viewModel: OnboardingViewModel,
        onboardingResponder: OnboardingResponder
    ) {
        self.viewModel = viewModel
        self.onboardingView = OnboardingView(onboardingResponder: onboardingResponder)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = onboardingView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brandPurpleColor
        onboardingView.setupView(with: viewModel)
    }
}

#warning("Readme")
