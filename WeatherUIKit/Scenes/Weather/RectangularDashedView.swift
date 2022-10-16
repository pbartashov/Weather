//
//  RectangularDashedView.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 12.10.2022.
//
//https://medium.com/@mail.asifnewaz/dashed-line-border-around-a-uiview-96abb81da560

import UIKit

final class RectangularDashedView: UIView {

    // MARK: - Properties

    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    var dashWidth: CGFloat = 0
    var dashColor: UIColor = .clear
    var dashLength: CGFloat = 0
    var betweenDashesSpace: CGFloat = 0

    private var dashBorder: CAShapeLayer?


//    override var intrinsicContentSize: CGSize {
//        CGSize(width: 0, height: dashWidth)
//    }
    // MARK: - Views

    // MARK: - LifeCicle

    // MARK: - Metods

    init() {
        super.init(frame: .zero)
//        setup()
//        backgroundColor = .brandPurpleColor

    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }

//    private func setup() {
//        height(3)
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.strokeColor = UIColor.gray.cgColor
//        shapeLayer.lineWidth = 1
//        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
//        shapeLayer.lineDashPattern = [2, 4]
//        let path = CGMutablePath()
//        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: UIScreen.main.bounds.width, y: 0)])
//        shapeLayer.path = path
//        layer.addSublayer(shapeLayer)
//    }
}
//    enum Direction {
//        case horizontal
//        case vertiacal
//    }
//
//
//        var lineWidth: CGFloat = 0.5
//
//        override var intrinsicContentSize: CGSize {
//            .init(width: 0, height: lineWidth)
//        }
//
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .brandPurpleColor
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setColor(_ color: UIColor) {
//        backgroundColor = color
//    }

//}
