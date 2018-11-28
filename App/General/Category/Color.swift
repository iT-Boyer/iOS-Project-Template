/**
 App 颜色定义
 */
extension UIColor {
    /// 全局主题色
    @objc static let tint: UIColor = #colorLiteral(red: 0.1843137255, green: 0.4862745098, blue: 0.9647058824, alpha: 1)
    
    /// 全局高亮色
    @objc static let tintHighlighted: UIColor = #colorLiteral(red: 0.380243797, green: 0.6063924431, blue: 0.9647058824, alpha: 1)
    
    /// 深色文字
    @objc static let darkText: UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
    
    /// 浅色文字
    @objc static let lightText: UIColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
    
    /// UITextField 默认的占位符颜色
    @objc static let systemPlaceholderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0.09803921569, alpha: 0.22)
    
    /// 全局按钮禁用背景色
    @objc static let buttonDisabled: UIColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
}
