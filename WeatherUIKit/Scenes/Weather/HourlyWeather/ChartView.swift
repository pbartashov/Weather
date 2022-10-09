//
//  ChartView.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 05.10.2022.
//
//https://www.raywenderlich.com/10946920-core-chartics-tutorial-gradients-and-contexts

import UIKit

final class ChartView: UIView {

    typealias Offset = CGPoint

    // MARK: - Properties

    // MARK: - Views



    // 1
//    var startGradientColor: UIColor = .black
//    var endGradientColor: UIColor = .white
    var contentInset: UIEdgeInsets = .zero

    var gradientColors: [UIColor] = []
    var gradientColorLocations: [CGFloat] = []
    var gradientBorderColor: UIColor = .black
    var gradientBorderWidth: CGFloat = 1.0

    var pointColor: UIColor = .white
    var lineColor: UIColor = .black

    var lineWidth: CGFloat = 1.0
    var graphPointRadius: CGFloat = 2.0

    var xAxisColor: UIColor = .black
    var xAxisPointColor: UIColor = .black
    var xAxisWidth: CGFloat = 1.0

    var pointLabelFont: UIFont = .preferredFont(forTextStyle: .body)
    var pointLabelColor: UIColor = .black
    var pointLabelOffset: Offset = .zero

    var xAxisInfoLabelFont: UIFont = .preferredFont(forTextStyle: .body)
    var xAxisInfoLabelColor: UIColor = .black

    var xAxisPointLabelFont: UIFont = .preferredFont(forTextStyle: .body)
    var xAxisPointLabelColor: UIColor = .black
    var xAxisPointLabelSize: CGSize = .zero

    var chartData: [Double] = []
    var chartDataLabels: [String] = []
    var xAxisInfoImages: [UIImage] = []
    var xAxisInfoTexts: [String] = []//["12%", "12%", "12%", "12%"]
    var xAxisLabelTexts: [String] = []//["12:00", "12:00", "12:00", "12:00"]

    var chartBottomBorder: CGFloat = 0
    var xAxisYPosition:CGFloat = 0
    var xAxisInfoImagesOffset: Offset = .zero
    var xAxisInfoOffset: Offset = .zero
    var xAxisLabelOffset: Offset = .zero



    // MARK: - LifeCicle


    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
//        print("🍄")
        let width = rect.width

        guard let context = UIGraphicsGetCurrentContext(), !chartData.isEmpty else {
            return
        }

         // Calculate the x point
        let margin = contentInset.left + contentInset.right
        let leftBorder = contentInset.left
        let chartWidth = width - margin
        let spacing = chartWidth / CGFloat(self.chartData.count - 1)
        guard chartWidth > 0 else { return }

        let columnXPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            return CGFloat(column) * spacing + leftBorder
        }

        // Calculate the y point
        let topBorder = contentInset.top + pointLabelFont.capHeight - pointLabelOffset.y
        let chartHeight = chartBottomBorder - topBorder
        guard chartHeight > 0 else { return }

        guard let maxValue = chartData.max() else {
            return
        }

        let columnYPoint = { (chartPoint: Double) -> CGFloat in
            let yPoint = CGFloat(chartPoint) / CGFloat(maxValue) * chartHeight
            return chartHeight + topBorder - yPoint // Flip the chart
        }

        // Create array of Graph points
        let chartPoints = chartData.enumerated().map { (i, value) in
            CGPoint(x: columnXPoint(i), y: columnYPoint(value))
        }

        guard let maxChartPoint = chartPoints.max(by: { $0.y < $1.y }) else {
            return
        }

        let drawChartAndGradient = { [self] in
            let colors = gradientColors.map { $0.cgColor }
            let colorSpace = CGColorSpaceCreateDeviceRGB()

            guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors as CFArray,
                locations: gradientColorLocations
            ) else {
                return
            }

            // Draw the line chart
            lineColor.setFill()
            lineColor.setStroke()

            let chartPath = UIBezierPath()

            chartPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(chartData[0])))

            for i in 1..<chartPoints.count {
                chartPath.addLine(to: chartPoints[i])
            }

            // Create the clipping path for the chart gradient
            context.saveGState()
            guard let clippingPath = chartPath.copy() as? UIBezierPath else {
                return
            }

            clippingPath.addLine(to: CGPoint( x: columnXPoint(chartData.count - 1),
                                              y: maxChartPoint.y))
            clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: maxChartPoint.y))
            clippingPath.close()

            clippingPath.addClip()

            let semiHeight = bounds.height / 2.0
            let chartStartPoint = CGPoint(x: contentInset.left, y: semiHeight)
            let chartEndPoint = CGPoint(x: width - contentInset.right, y: semiHeight)

            context.drawLinearGradient(
                gradient,
                start: chartStartPoint,
                end: chartEndPoint,
                options: [])
            context.restoreGState()

            // Draw the line on top of the clipped gradient
            chartPath.lineWidth = lineWidth
            chartPath.stroke()

            // Draw the circles on top of the chart stroke
            for i in 0..<chartData.count {
                var point = chartPoints[i]
                point.x -= graphPointRadius
                point.y -= graphPointRadius

                let circle = UIBezierPath(
                    ovalIn: CGRect(
                        origin: point,
                        size: CGSize(
                            width: graphPointRadius * 2,
                            height: graphPointRadius * 2)
                    )
                )
                circle.fill()
            }
        }

        let drawChartDataLabels = { [self] in
            for i in 0..<chartData.count {
                let point = chartPoints[i].offsetBy(dx: pointLabelOffset.x, dy: pointLabelOffset.y - pointLabelFont.capHeight)
                let string = NSAttributedString(string: chartDataLabels[i], attributes: [NSAttributedString.Key.font: pointLabelFont,
                                                                                         NSAttributedString.Key.foregroundColor: pointLabelColor])
                string.draw(at: point)
            }
        }

        let firstChartPoint = chartPoints[0]
        let lastChartPoint = chartPoints[chartPoints.count - 1]

        let drawChartBorderLines = { [self] in
            // Draw horizontal chart lines
            let linePath = UIBezierPath()
            let leftTopPoint = firstChartPoint.offsetBy(dx: -graphPointRadius, dy: graphPointRadius)
            let leftBottomPoint = CGPoint(x: leftTopPoint.x, y: maxChartPoint.y + graphPointRadius)
            let rightBottomPoint = CGPoint(x: lastChartPoint.x + graphPointRadius, y: maxChartPoint.y + graphPointRadius)
            let rightTopPoint = lastChartPoint.offsetBy(dx: graphPointRadius, dy: graphPointRadius)

            // Left line
            linePath.move(to: leftTopPoint)
            linePath.addLine(to: leftBottomPoint)

            // Bottom line
            linePath.addLine(to: rightBottomPoint)

            // Right line
            linePath.addLine(to: rightTopPoint)
            gradientBorderColor.setStroke()

            linePath.lineWidth = gradientBorderWidth

            let pattern: [CGFloat] = [3.0, 3.0]
            linePath.setLineDash(pattern, count: 2, phase: 0.0)
            linePath.stroke()
        }

        let drawAxisX = { [self] in
            // Draw X Axys line
            let linePath = UIBezierPath()

            linePath.move(to: CGPoint(x: firstChartPoint.x,
                                      y: xAxisYPosition))

            linePath.addLine(to: CGPoint(x: lastChartPoint.x,
                                         y: xAxisYPosition))

            self.xAxisColor.setStroke()

            linePath.lineWidth = xAxisWidth

            linePath.stroke()

            self.xAxisPointColor.setStroke()

            var point =  CGPoint(x: firstChartPoint.x,
                                 y: xAxisYPosition - xAxisPointLabelSize.height / 2)

            for chartPoint in chartPoints {
                point.x = chartPoint.x

                let rect = UIBezierPath(
                    rect: CGRect(
                        origin: point,
                        size: xAxisPointLabelSize)
                )
                rect.fill()
            }
        }

        let drawAxisXLabels = { [self] in
            let point =  CGPoint(x: firstChartPoint.x + xAxisLabelOffset.x,
                                 y: xAxisYPosition + xAxisLabelOffset.y)

            drawTextRow(startPoint: point, texts: xAxisLabelTexts, font: xAxisPointLabelFont, color: xAxisPointLabelColor)
        }

        let drawAxisXInfoTexts = { [self] in
            let point =  CGPoint(x: firstChartPoint.x + xAxisInfoOffset.x,
                                 y: xAxisYPosition + xAxisInfoOffset.y)

            drawTextRow(startPoint: point, texts: xAxisInfoTexts, font: xAxisInfoLabelFont, color: xAxisInfoLabelColor)
        }

        func drawTextRow(startPoint: CGPoint, texts: [String], font: UIFont, color: UIColor) {
            var point = startPoint

            for (chartPoint, text) in zip(chartPoints, texts) {
                point.x = chartPoint.x
                let string = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font,
                                                                           NSAttributedString.Key.foregroundColor: color])
                string.draw(at: point)
            }
        }

        let drawAxisXInfoImages = { [self] in
            var point =  CGPoint(x: firstChartPoint.x + xAxisInfoImagesOffset.x,
                                 y: xAxisYPosition + xAxisInfoImagesOffset.y)

            for (chartPoint, image) in zip(chartPoints, xAxisInfoImages) {
                point.x = chartPoint.x

                image.draw(at: point)
            }
        }

        drawChartAndGradient()
        drawChartDataLabels()
        drawChartBorderLines()
        drawAxisX()
        drawAxisXLabels()
        drawAxisXInfoTexts()
        drawAxisXInfoImages()





        // MArker
        //        UIColor.blue.setFill()
        //        UIColor.blue.setStroke()

        //        var point = CGPoint(x: contentInset.right,
        //                            y: chartBottomBorder * 2)
        //
        //        point.x -= graphPointRadius
        //        point.y -= graphPointRadius
        //
        //        let circle = UIBezierPath(
        //            ovalIn: CGRect(
        //                origin: point,
        //                size: CGSize(
        //                    width: graphPointRadius * 2,
        //                    height: graphPointRadius * 2)
        //            )
        //        )
        //        circle.fill()


    }


    // MARK: - Metods



    private func initialize() {

        [].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {

    }


    func setup(chartData: [Double],
               chartDataLabels: [String],
               xAxisInfoImages: [UIImage],
               xAxisInfoTexts: [String],
               xAxisLabelTexts: [String]
    ) {
        self.chartData = chartData
        self.chartDataLabels = chartDataLabels
        self.xAxisInfoImages = xAxisInfoImages
        self.xAxisInfoTexts = xAxisInfoTexts
        self.xAxisLabelTexts = xAxisLabelTexts

        self.setNeedsDisplay()
    }
}
