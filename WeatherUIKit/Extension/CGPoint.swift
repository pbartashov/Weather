//
//  CGPoint.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 06.10.2022.
//

import UIKit

extension CGPoint {
    /// Retuns the point which is an offset of an existing point.
    ///
    /// - Parameters:
    ///   - dx: The x-coordinate offset to apply.
    ///   - dy: The y-coordinate offset to apply.
    ///
    /// - Returns:
    ///   A new point which is an offset of an existing point.
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }

    func offsetBy(_ offset: CGPoint) -> CGPoint {
        return CGPoint(x: x + offset.x, y: y + offset.y)
    }
}
