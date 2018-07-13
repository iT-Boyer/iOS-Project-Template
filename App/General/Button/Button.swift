/**
 应用级别的按钮定制
 */

/**
 定义样式名
 
 一般在 Interface Builder 中通过 styleName 设置
 */
enum ButtonStyle: String {
    /// 默认按钮
    case std
}

/**
 应用级别按钮
 */
class Button: MBButton {
    override func setupAppearance() {
        guard let style = styleName else {
            return
        }
        switch style {
        case ButtonStyle.std.rawValue:
            // todo 设置样式
            break
            
        default: break
        }
    }
    
    @IBInspectable var jumpURL: String?
    
    override func onButtonTapped() {
        super.onButtonTapped()
        if jumpURL != nil {
            AppNavigationJump(jumpURL, nil)
        }
    }
}
