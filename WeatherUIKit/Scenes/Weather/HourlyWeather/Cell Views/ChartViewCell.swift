//
//  ChartViewCell.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 05.10.2022.
//

import SnapKit
import UIKit

final class ChartViewCell: UICollectionViewCell {

    // MARK: - Views

    private let chartView: ChartView = {
        let chart = ChartViewFactory().makeWeatherGraph()

        return chart
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
        contentView.backgroundColor = .brandLightGray
        addSubview(chartView)

        setupLayouts()
    }

    private func setupLayouts() {
        chartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setup(chartData: [Double],
               chartDataLabels: [String],
               infoImages: [UIImage],
               infoTexts: [String],
               labelTexts: [String])
    {
        chartView.setup(chartData: chartData,
                        chartDataLabels: chartDataLabels,
                        xAxisInfoImages: infoImages,
                        xAxisInfoTexts: infoTexts,
                        xAxisLabelTexts: labelTexts)
        
    }
}
