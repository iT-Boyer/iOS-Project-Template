/**
 应用级别的便捷方法
 */
extension UIButton {

    // @MBDependency:3
    /**
     便捷读取/设置当前状态的文字
     
     为了和 UILabel 等控件的设置方式一致
     
     注意：设置时如果当前状态的文字未设置，则修改默认状态的文字；这么做符合多数情况下的意图
     */
    @objc var text: String? {
        get {
            return currentTitle
        }
        set {
            if title(for: state) != nil {
                setTitle(newValue, for: state)
            } else {
                setTitle(newValue, for: .normal)
            }
        }
    }
}
