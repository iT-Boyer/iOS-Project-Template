/*
 RingView.swift

 Copyright © 2021 BB9z
 https://github.com/BB9z/iOS-Project-Template

 The MIT License
 https://opensource.org/licenses/MIT
 */

/**
 圆环 view
 */
@IBDesignable
class RingView: UIView {
    @IBInspectable var color: UIColor = .red {
        didSet {
            needsUpdateStyle = true
        }
    }
    @IBInspectable var lineWidth: CGFloat = 2 {
        didSet {
            needsUpdateStyle = true
        }
    }

    private var shapeLayer: CAShapeLayer!

    private var needsUpdateStyle = false {
        didSet {
            guard needsUpdateStyle, !oldValue else { return }
            DispatchQueue.main.async { [self] in
                if needsUpdateStyle { updateLayerStyle() }
            }
        }
    }

    private func updateLayerStyle() {
        needsUpdateStyle = false
        if shapeLayer == nil {
            shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = nil
            layer.insertSublayer(shapeLayer, at: 0)
        }
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = color.cgColor
        let inset = lineWidth / 2
        shapeLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: inset, dy: inset)).cgPath
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateLayerStyle()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updateLayerStyle()
    }
}
