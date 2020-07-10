/**
 应用级别的便捷方法
 */

// NSRegularExpression 的创建比较耗时，需反复使用的建议使用缓存
extension NSRegularExpression {
    // @MBDependency:1 范例性质
    /// 中日韩字符
    static let CJKChar: NSRegularExpression = try! NSRegularExpression(pattern: "\\p{InCJK}", options: .caseInsensitive)
    // swiftlint:disable:previous force_try
}
