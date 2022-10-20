//
//  ChartViewFactory.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 06.10.2022.
//

import UIKit

struct ChartViewFactory {
    func makeWeatherGraph() -> ChartView {
        let chartView = ChartView()
        chartView.backgroundColor = .brandLightGray
        chartView.contentInset = UIEdgeInsets(top: 11, left: ConstantsUI.leadingMargin,
                                              bottom: 8, right: ConstantsUI.trailingMargin + 34)

        chartView.gradientColors = [UIColor(red: 61 / 255, green: 105 / 255, blue: 220 / 225, alpha: 0.3),
                                    UIColor(red: 32 / 255, green: 78 / 255, blue: 199 / 225, alpha: 0.3),
                                    UIColor(red: 32 / 255, green: 78 / 255, blue: 199 / 225, alpha: 0)]

        chartView.gradientColorLocations = [0.0, 0.0, 1.0]

        chartView.lineWidth = 0.3
        chartView.lineColor = .brandPurpleColor
        chartView.gradientBorderWidth = 0.3
        chartView.gradientBorderColor = .brandPurpleColor
        chartView.chartBottomBorder = 47
        chartView.graphPointRadius = 2

        chartView.pointColor = .white
        chartView.xAxisColor = .brandPurpleColor
        chartView.xAxisPointColor = .brandPurpleColor
        chartView.xAxisWidth = 0.5
        chartView.xAxisInfoImagesOffset = .init(x: 3, y: 68 - 116)
        chartView.xAxisInfoOffset = .init(x: 0, y: 88 - 116)
        chartView.xAxisYPosition = 116
        chartView.xAxisLabelOffset = .init(x: -2, y: 128 - 116)
        chartView.xAxisPointLabelSize = .init(width: 4, height: 8)
        chartView.pointLabelFont = .systemFont(ofSize: 14)
        chartView.pointLabelColor = .brandTextColor
        chartView.pointLabelOffset = .init(x: -2, y: -8)

        chartView.xAxisInfoLabelFont = .systemFont(ofSize: 12)
        chartView.xAxisInfoLabelColor = .brandTextColor

        chartView.xAxisPointLabelFont = .systemFont(ofSize: 14)
        chartView.xAxisPointLabelColor = .brandTextColor

        return chartView
    }
}
