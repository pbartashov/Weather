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

    // MARK: - Metods

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
}
