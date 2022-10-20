//
//  IconedLabeledValue.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 10.10.2022.
//

import UIKit

final class ImagedLabeledValue: UIView {

    // MARK: - Properties

    var imageSectionWidth: CGFloat = 0 {
        didSet {
            setupLayouts()
        }
    }

    var trailingMargin: CGFloat = 0 {
        didSet {
            setupLayouts()
        }
    }

    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    var labelText: String? {
        get {
            centerLabel.text
        }
        set {
            centerLabel.text = newValue
        }
    }

    var valueText: String? {
        get {
            rightLabel.text
        }
        set {
            rightLabel.text = newValue
        }
    }

    var spacing: CGFloat {
        get {
            stackView.spacing
        }
        set {
            stackView.spacing = newValue
        }
    }

    // MARK: - Views

    let imageView: UIImageView = {
        $0.setContentHuggingPriority(.required, for: .horizontal)

        return $0
    }(UIImageView())


    let centerLabel: UILabel = {
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingMiddle

        return $0
    }(UILabel())


    let rightLabel: UILabel = {
        $0.textAlignment = .right

        return $0
    }(UILabel())

    let stackView: UIStackView = {
        $0.alignment = .center

        return $0
    }(UIStackView())

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
         rightLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        [imageView,
         stackView
        ].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        imageView.snp.remakeConstraints { make in
            make.centerX.equalTo(self.snp.leading).offset(imageSectionWidth / 2)
            make.centerY.equalToSuperview()
        }

        stackView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(imageSectionWidth)
            make.trailing.equalToSuperview().offset(-trailingMargin)
        }
    }
}
