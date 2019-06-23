/*
 应用级别的便捷方法
 */
extension Sequence where Iterator.Element: Hashable {
    /// 返回去重的序列
    func uniqued() -> [Iterator.Element] {
        var seen = [Iterator.Element: Bool]()
        return filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
