//
//  SunMoonPanel.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 11.10.2022.
//

import UIKit

final class SunMoonPanel: UIView {

    // MARK: - Properties

    var image: UIImage? {
        get {
            durationRow.image
        }
        set {
            durationRow.image = newValue
        }
    }

    var duration: String? {
        get {
            durationRow.valueText
        }
        set {
            durationRow.valueText = newValue
        }
    }

    var riseEpoch: String? {
        get {
            riseRow.valueText
        }
        set {
            riseRow.valueText = newValue
        }
    }

    var setEpoch: String? {
        get {
            setRow.valueText
        }
        set {
            setRow.valueText = newValue
        }
    }

//    override var spacing: CGFloat {
//        didSet {
//            setupLayouts()
//        }
//    }

//    var e

    // MARK: - Views

    private lazy var durationRow: ImagedLabeledValue = {
        let row = ImagedLabeledValue()
        //  row.spacing = 15
        row.imageSectionWidth = 20

        row.rightLabel.font = .systemFont(ofSize: 16)
        row.rightLabel.textColor = .brandTextColor

        return row
    }()

    private lazy var durationRiseSeparator = makeSeparator()

    private lazy var riseRow = makeRow(labelText: "Восход")

    private lazy var riseSetSeparator = makeSeparator()

    private lazy var setRow = makeRow(labelText: "Заход")

    // MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)

//        defer {
            initialize()
//        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {
//        axis = .vertical
//        spacing = 16

        [durationRow,
         durationRiseSeparator,
         riseRow,
         riseSetSeparator,
         setRow
        ].forEach {
            self.addSubview($0)
        }

//        [durationRiseSeparator,
//         riseSetSeparator
//        ].forEach {
//            self.addSubview($0)
//        }


        setupLayouts()
    }

    private func setupLayouts() {
        durationRow.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-5)
        }

        durationRiseSeparator.snp.makeConstraints { make in
            make.top.equalTo(durationRow.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.3)
        }

        riseRow.snp.makeConstraints { make in
            make.top.equalTo(durationRiseSeparator.snp.bottom).offset(8)
            make.leading.trailing.equalTo(durationRow)
        }

        riseSetSeparator.snp.makeConstraints { make in
            make.top.equalTo(riseRow.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.3)
        }

        setRow.snp.makeConstraints { make in
            make.top.equalTo(riseSetSeparator.snp.bottom).offset(8)
            make.leading.trailing.equalTo(durationRow)
            make.bottom.equalToSuperview().offset(-1)
        }
    }

    private func makeRow(labelText: String) -> ImagedLabeledValue {
        let row = ImagedLabeledValue()
        row.spacing = 15
        row.centerLabel.font = .systemFont(ofSize: 14)
        row.centerLabel.textColor = .brandTextGrayColor

        row.rightLabel.font = .systemFont(ofSize: 16)
        row.rightLabel.textColor = .brandTextColor

        row.labelText = labelText

        return row
    }

    private func makeSeparator() -> UIView {
        let separator = RectangularDashedView()
        separator.dashWidth = 0.3
        separator.dashColor = .brandPurpleColor
        separator.dashLength = 3
        separator.betweenDashesSpace = 3

        return separator
    }
}
