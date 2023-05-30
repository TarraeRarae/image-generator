//
//  CustomTabbar.swift
//  image-generator
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import UIKit

class CustomTabBar: UITabBar {

    // MARK: State

    private var shapeLayer: CALayer?

    // MARK: Lifecycle

    override func draw(_ rect: CGRect) {
        addShape()
        addShadow()
    }
}

// MARK: - UI methods

private extension CustomTabBar {

    func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: CGRect(
                x: 0,
                y: -Constants.horizontalOffset,
                width: frame.width,
                height: frame.height + Constants.horizontalOffset * 2
            ),
            cornerRadius: Constants.cornerRadius
        )

        return path.cgPath
    }

    func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.grayBackground.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0

        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 100
        layer.shadowOpacity = 0.12
    }
}

// MARK: - Constants

private extension CustomTabBar {

    enum Constants {
        static let horizontalOffset: CGFloat = 10
        static let cornerRadius: CGFloat = 20
    }
}
