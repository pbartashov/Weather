//
//  HourlyWeatherHeaderView.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 02.10.2022.
//

import UIKit
import Combine

final class WeatherSectionHeaderView: UICollectionReusableView {
    enum Button {
        case button
    }

    // MARK: - Properties

    private let buttonTappedSubject = PassthroughSubject<Button, Never>()
    var buttonTappedPublisher: AnyPublisher<Button, Never> {
        buttonTappedSubject.eraseToAnyPublisher()
    }
    // MARK: - Views


    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        return stackView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .brandTextColor

        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.brandTextColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()
    // MARK: - LifeCicle


    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()



    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Metods
    private func initialize() {
        addSubview(stackView)

        [label, button].forEach {
            stackView.addArrangedSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(labelTitle: String? = nil,
               buttonTitle: String? = nil
    ) {
        label.text = labelTitle
        button.setUnderlinedTitle(buttonTitle, for: .normal)
    }

    @objc func buttonTapped() {
        buttonTappedSubject.send(.button)
    }
}

