//
//  HourlyWeatherDetailedViewCellRow.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 05.10.2022.
//

import UIKit

final class HourlyWeatherDetailedViewCellRow: UIView {

    // MARK: - Properties
    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    var centerText: String? {
        get {
            centerLabel.text
        }
        set {
            centerLabel.text = newValue
        }
    }
    var rightText: String? {
        get {
            rightLabel.text
        }
        set {
            rightLabel.text = newValue
        }
    }
    
    // MARK: - Views

    let imageView: UIImageView = {
        $0.setContentHuggingPriority(.required, for: .horizontal)

        return $0
    }(UIImageView())


    let centerLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .brandTextColor
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingMiddle

        return $0
    }(UILabel())
    
    
    let rightLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .brandTextGrayColor
        $0.textAlignment = .right

        return $0
    }(UILabel())

    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.alignment = .center

        return stack
    }()



    // MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

        private func initialize() {
            [centerLabel,
             rightLabel].forEach {
                stackView.addArrangedSubview($0)
            }

            [imageView,
             stackView].forEach {
                self.addSubview($0)
            }

            setupLayouts()
        }

        private func setupLayouts() {
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.centerX.equalTo(self.snp.leading).offset(12)
            }

            stackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview()
            }
        }
}

