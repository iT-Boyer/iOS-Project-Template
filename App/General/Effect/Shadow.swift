/*
 Shadow.swift

 Copyright © 2018, 2020-2021 BB9z
 https://github.com/BB9z/iOS-Project-Template

 The MIT License
 https://opensource.org/licenses/MIT
 */

// @MBDependency:3
/**
 阴影 view
 */
@IBDesignable
class ShadowView: UIView {
    @IBInspectable var shadowOffset: CGPoint = CGPoint(x: 0, y: 8) {
        didSet {
            needsUpdateStyle = true
        }
    }
    @IBInspectable var shadowBlur: CGFloat = 10 {
        didSet {
            needsUpdateStyle = true
        }
    }
    @IBInspectable var shadowSpread: CGFloat = 0 {
        didSet {
            needsUpdateStyle = true
        }
    }
    @IBInspectable var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            needsUpdateStyle = true
        }
    }

    override var bounds: CGRect {
        didSet {
            lastLayerSize = bounds.size
        }
    }

    private var lastLayerSize = CGSize.zero {
        didSet {
            if oldValue == lastLayerSize { return }
            let rect = layer.bounds.inset(by: UIEdgeInsetsMakeWithSameMargin(-shadowSpread))
            layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateLayerStyle()
    }

    private var needsUpdateStyle = false {
        didSet {
            if needsUpdateStyle {
                DispatchQueue.main.async { [self] in
                    if !needsUpdateStyle { return }
                    needsUpdateStyle = false
                    updateLayerStyle()
                }
            }
        }
    }

    private func updateLayerStyle() {
        Shadow(view: self, offset: shadowOffset, blur: shadowBlur, spread: shadowSpread, color: shadowColor, cornerRadius: cornerRadius)
    }
}

// swiftlint:disable identifier_name
/**
 给一个 view 的 layer 设置阴影样式
 
 生成的阴影无论参数还是效果与 Sketch 应用一致
 */
func Shadow(view: UIView?, offset: CGPoint, blur: CGFloat, spread: CGFloat, color: UIColor, cornerRadius: CGFloat = 0) {
    guard let layer = view?.layer else {
        return
    }
    layer.shadowColor = color.cgColor
    layer.shadowOffset = CGSize(width: offset.x, height: offset.y)
    layer.shadowRadius = blur
    layer.shadowOpacity = 1
    layer.cornerRadius = cornerRadius

    let rect = layer.bounds.inset(by: UIEdgeInsetsMakeWithSameMargin(-spread))
    layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
}
// swiftlint:enable identifier_name
