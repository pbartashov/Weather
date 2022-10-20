//
//  DailyWeatherDaysCollectionViewCell.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 10.10.2022.
//

import UIKit

final class DailyWeatherDaysCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            toggleSelectedAppearance()
        }
    }

    // MARK: - Views

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center

        return label
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
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true

        contentView.addSubview(dateLabel)

        setupLayouts()
    }

    private func setupLayouts() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
            make.bottom.equalToSuperview().offset(-7)
        }
    }

    func setup(with text: String) {
        dateLabel.text = text
    }

    func toggleSelectedAppearance() {
        dateLabel.textColor = .brandTextGrayColor
        UIView.transition(with: dateLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve) { [isSelected, contentView, dateLabel] in
            if isSelected {
                dateLabel.textColor = .white
                contentView.backgroundColor = .brandPurpleColor
            } else {
                dateLabel.textColor = .brandTextColor
                contentView.backgroundColor = .white
            }
        }
    }

    func setSelectedAppearence() {
        contentView.backgroundColor = .brandPurpleColor
        dateLabel.textColor = .white
    }

    func setDeselectedAppearence() {
        contentView.backgroundColor = .clear
        dateLabel.textColor = .brandTextColor
    }
}
