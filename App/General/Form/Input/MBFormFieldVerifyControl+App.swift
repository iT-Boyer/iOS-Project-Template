/*
应用级别的便捷方法
*/

/// 输入框是 TextField 下的增强
extension MBFormFieldVerifyControl {

    /// 给 invaildSubmitButton 添加点击事件，不通过时自动提示
    @IBInspectable var addInvaildAction: Bool {
        get {
            NSLog("⚠️ MBFormFieldVerifyControl: addInvaildAction getter unavailable.")
            return false
        }
        set {
            guard newValue else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let sf = self else { return }
                guard let button = sf.invaildSubmitButton else {
                    NSLog("❌ MBFormFieldVerifyControl: invaildSubmitButton not set.")
                    return
                }
                if let control = button as? UIControl {
                    control.addTarget(sf, action: #selector(sf.onInvaildSubmit(_:)), for: .touchUpInside)
                } else if let item = button as? UIBarButtonItem {
                    item.target = sf
                    item.action = #selector(sf.onInvaildSubmit(_:))
                } else {
                    fatalError("Unexcept type.")
                }
            }
        }
    }

    @IBAction func onInvaildSubmit(_ sender: Any) {
        noticeIfInvaild(becomeFirstResponder: true)
    }

    /// 获取验证结果，不通过时可提示并切换焦点
    func noticeIfInvaild(becomeFirstResponder: Bool = true) {
        if isValid { return }
        guard let fields = textFields as? [TextField] else { return }
        for aField in fields {
            if validationSkipsHiddenFields && !aField.isVisible { continue }
            guard nil != aField.vaildFieldText(noticeWhenInvaild: true, becomeFirstResponderWhenInvaild: true) else {
                return
            }
        }
    }
}
