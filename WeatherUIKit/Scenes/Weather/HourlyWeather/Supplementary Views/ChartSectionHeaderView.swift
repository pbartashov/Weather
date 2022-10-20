//
//  ChartSectionHeaderView.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 04.10.2022.
//

import UIKit

final class ChartSectionHeaderView: UICollectionReusableView {

    // MARK: - Views

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .brandTextColor

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
        addSubview(label)
        setupLayouts()
    }

    private func setupLayouts() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setup(labelTitle: String) {
        label.text = labelTitle
    }
}
