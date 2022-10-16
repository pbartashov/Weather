//
//  EmptyWeathersCell.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 04.10.2022.
//

import SnapKit
import WeatherKit

final class LoadingCell: UICollectionViewCell {

    // MARK: - Properties

    // MARK: - Views

    private let activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.startAnimating()
        activity.color = .brandYellow

        return activity
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "Loading..."

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
        contentView.layer.cornerRadius = 22
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.brandLightPurple.cgColor

        contentView.backgroundColor = .brandPurpleColor


                [activity,
                 label
                ].forEach {
                    contentView.addSubview($0)
                }

        setupLayouts()
    }

    private func setupLayouts() {
        activity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(activity.snp.bottom).offset(16)
        }
    }
}
