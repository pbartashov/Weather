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

    private let addLocationResponder: AddLocationResponder

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

    public init(addLocationResponder: AddLocationResponder) {
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
        view.backgroundColor = .white
        view.addSubview(addButton)
        setupLayout()
    }

    private func setupLayout() {
        addButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
