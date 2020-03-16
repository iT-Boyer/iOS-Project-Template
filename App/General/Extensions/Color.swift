/*
 App 颜色定义
 */
extension UIColor {
    /// 比当前颜色浅一些的颜色
    @objc(rf_lighterColor) func rf_lighter() -> UIColor {
        return mixedColor(withRatio: 0.8, color: .white)
    }

    /// 比当前颜色深一些的颜色
    @objc(rf_darkerColor) func rf_darker() -> UIColor {
        return mixedColor(withRatio: 0.8, color: .black)
    }
}
