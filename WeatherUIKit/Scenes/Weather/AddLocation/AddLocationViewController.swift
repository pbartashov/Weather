//
//  AddLocationViewController.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 15.10.2022.
//

import UIKit
import WeatherKit



public final class AddLocationViewController: UIViewController {

    
    // MARK: - Properties

//    private let viewModel: MainViewModel
    private let addLocationResponder: AddLocationResponder


    // Factories
//    let makeWeatherViewController: (Int) -> WeathersViewController
//    let makeSettingsViewController: () -> SettingsViewController


    // MARK: - Views

    private lazy var addButton: UIButton = {
        let button = UIButton()

        button.titleLabel?.font = .systemFont(ofSize: 150, weight: .bold)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.brandTextColor, for: .normal)

        button.addTarget(addLocationResponder,
                         action: #selector(AddLocationResponder.handleAddLocation),
                         for: .touchUpInside)

        return button
    }()

    // MARK: - LifeCicle

    //    init() {
    //        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    //    }

    public init(
        addLocationResponder: AddLocationResponder
//        viewModel: MainViewModel,
//        weatherViewControllerFactory: @escaping (Int) -> WeathersViewController,
//        settingsViewControllerFactory: @escaping ()-> SettingsViewController
    ) {
//        self.viewModel = viewModel
//        self.makeWeatherViewController = weatherViewControllerFactory
//        self.makeSettingsViewController = settingsViewControllerFactory
        self.addLocationResponder = addLocationResponder

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }



    public override func viewDidLoad() {
        super.viewDidLoad()






        initialize()
    }





    // MARK: - Metods

    private func initialize() {
//        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        view.backgroundColor = .white
        view.addSubview(addButton)
        setupLayout()
    }

    private func setupLayout() {
        addButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

    }
//
//    @objc private func addButtonTapped() {
//
//    }



}


