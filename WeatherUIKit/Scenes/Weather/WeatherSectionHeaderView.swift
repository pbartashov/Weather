//
//  HourlyWeatherHeaderView.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 02.10.2022.
//

import UIKit

class WeatherSectionHeaderView: UICollectionReusableView {

   let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        return stackView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label

        return label
    }()

    let seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("Подробнее на 24 часа", for: .normal)
        button.setTitleColor(.brandTextColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setContentHuggingPriority(.required, for: .horizontal)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        ])

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(seeAllButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        label.text = title
    }
}

