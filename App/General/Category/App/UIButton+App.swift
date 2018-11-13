/**
 应用级别的便捷方法
 */
extension UIButton {
    
    // @MBDependency:3
    /**
     便捷读取/设置当前状态的文字
     
     为了和 UILabel 等控件的设置方式一致
     */
    @objc var text: String? {
        get {
            return currentTitle
        }
        set {
            setTitle(text, for: state)
        }
    }
}
