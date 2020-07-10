/*
 应用级别的便捷方法
 */
extension String {

    // @MBDependency:4
    /// 非空，结合空的判断使用起来更容易些
    var isNotEmpty: Bool {
        return !isEmpty
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
        if str1 != nil && str2 != nil {
            return String(format: "%@%@%@", str1!, separator, str2!)
        }
        if str1 != nil {
            return str1!
        }
        if str2 != nil {
            return str2!
        }
        return ""
    }
}
