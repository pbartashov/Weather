//
//  SettingsRow.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit

final class SettingsRow: UIView {

    // MARK: - Properties

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
         actions: [UIAction]) {

        super.init(frame: .zero)

        titleLabel.text = title

        actions.enumerated().forEach { (index, action) in
            self.selector.insertSegment(action: action, at: index, animated: false)
        }

        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {

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

    func setSelectedIndex(_ index: Int) {
        selector.selectedSegmentIndex = index
    }
}
