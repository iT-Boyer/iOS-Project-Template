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
}
