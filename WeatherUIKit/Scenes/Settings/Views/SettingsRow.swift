//
//  SettingsRow.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit
import WeatherKit

protocol SettingsRawRepresentable {
    var title: String { get }
}

final class SettingsRow<T: Equatable&SettingsRawRepresentable>: UIView {

    // MARK: - Properties

    private let values: [T]
    var currentValue: T?

    // MARK: - Views

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textColor = .brandDarkGray

        return label
    }()

    private let selector: UISegmentedControl = {
        let font = UIFont.systemFont(ofSize: 16)
        let selector = UISegmentedControl()

        selector.setTitleTextAttributes([.foregroundColor: UIColor.white,
                                         .font: font],
                                        for: .selected)
        selector.setTitleTextAttributes([.font: font], for: .normal)

        selector.selectedSegmentTintColor = UIColor(red: 31 / 255, green: 77 / 255, blue: 197 / 255, alpha: 1)

        return selector
    }()

    // MARK: - LifeCicle

    init(title: String,
         values: [T]) {
        self.values = values
        super.init(frame: .zero)
        titleLabel.text = title

        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {
        values.enumerated().forEach { (index, value) in
            let action = UIAction(title: value.title) { [weak self] _ in
                guard let self = self else { return }
                self.currentValue = self.values[self.selector.selectedSegmentIndex]
            }
            selector.insertSegment(action: action, at: index, animated: false)
        }

        [titleLabel,
         selector
        ].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }

        selector.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(titleLabel)
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
    }

    func setSelected(value: T) {
        if let index = values.firstIndex(of: value) {
            selector.selectedSegmentIndex = index
        }
    }
}

extension Settings.Temperature: SettingsRawRepresentable {
    var title: String {
        switch self {
            case .celcius:
                return "C"

            case .farenheit:
                return "F"
        }
    }
}

extension Settings.Speed: SettingsRawRepresentable {
    var title: String {
        switch self {
            case .miles:
                return "Mi"

            case .kilometers:
                return "Km"
        }
    }
}

extension Settings.TimeFormat: SettingsRawRepresentable {
    var title: String {
        switch self {
            case .format12:
                return "12"

            case .format24:
                return "24"
        }
    }
}

extension Settings.Notifications: SettingsRawRepresentable {
    var title: String {
        switch self {
            case .enabled:
                return "On"

            case .disabled:
                return "Off"
        }
    }
}
