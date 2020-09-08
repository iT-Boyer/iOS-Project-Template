import UIKit

/*:

 我一般用 playground 辅助实现，验证简短的方法

 Playground 可以通过 framework 的方式载入项目和第三方代码；
 载入 Storyboard 中的视图也是支持的，但不推荐，因为资源文件必须是编译好的，需要手动或通过脚本拷贝，不如用 SwiftUI 预览特性（见 UIKitPreview.swift）

 ### 参考

 * [Playground Support - Apple Developer Documentation](https://developer.apple.com/documentation/playgroundsupport)
 * [Add a color, file, or image literal to a playground - Xcode Help](https://help.apple.com/xcode/mac/11.4/#/dev4c60242fc)
 * [Use a custom framework in a playground - Xcode Help](https://help.apple.com/xcode/mac/10.0/#/devc9b33111c)
 */

extension String {
    /// 手机号/电话号打码
    /// 支持任意长度
    func phoneMasked(_ mask: Character = Character("*")) -> String {
        guard !isEmpty else { return self }
        // 用系数算可以支持任意长度的输入
        // 系数是可以计算的，但这里写死的可读性好
        let length = Double(count)
        let maskCount = Int((length / 11.0 * 4.0).rounded())
        guard maskCount > 0 else { return self }
        let maskString = String(repeating: mask, count: maskCount)
        let rangeStart = index(startIndex, offsetBy: Int((length * 0.29).rounded()))
        let rangeEnd = index(rangeStart, offsetBy: maskCount - 1)
        var str = self
        str.replaceSubrange(rangeStart...rangeEnd, with: maskString)
        assert(str.count == self.count)
        return str
    }
}

"1".phoneMasked()
"12".phoneMasked()
"123".phoneMasked()
"1234".phoneMasked()
"12345".phoneMasked()
"123456".phoneMasked()
"1234567".phoneMasked()
"12345678".phoneMasked()
"123456789".phoneMasked()
"1234567890".phoneMasked()
"12345678901".phoneMasked()
"123456789012".phoneMasked()
