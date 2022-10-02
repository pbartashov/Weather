//
//  SettingsViewController.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit
import Combine

public final class SettingsViewController: UIViewController {


    // MARK: - Properties

    // MARK: - Views

    private let settingsView = SettingsView()

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - LifeCicle

    public override func loadView() {
        view = settingsView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .brandBlue
        navigationController?.navigationBar.tintColor = .brandLightGray
//        setupViewModel()

        bindView()
    }



    // MARK: - Metods

    private func bindView() {
        settingsView
            .buttonTappedPublisher
            .sink { [weak self] button in
                switch button {
                    case .setup:
                        self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &subscriptions)
    }
//    private func setupViewModel() {
//
//    }


}
