/*
 应用级别的便捷方法
 */
extension String {

    // @MBDependency:4
    /// 非空，结合空的判断使用起来更容易些
    var isNotEmpty: Bool {
        !isEmpty
    }

    // @MBDependency:4
    /// 应用级别行为，输入预处理，
    func trimmed() -> String? {
        let str = trimmingCharacters(in: .whitespaces)
        return str.isNotEmpty ? str : nil
    }

    // @MBDependency:3
    /// 用 separator 连接两个 string
    static func join(_ str1: String?, _ str2: String?, separator: String = "") -> String {
        if let str1 = str1, let str2 = str2 {
            return String(format: "%@%@%@", str1, separator, str2)
        }
        if let str = str1 { return str }
        if let str = str2 { return str }
        return ""
    }

    // @MBDependency:3
    /// 检查是否符合给定正则表达式
    func matches(regularExpression pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression) != nil
    }

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
        return str
    }
}
