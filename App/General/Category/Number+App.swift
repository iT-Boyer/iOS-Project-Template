/**
 应用级别的便捷方法
 */
extension Double {
    /// ¥xx.xx 价格的格式
    func priceString(addPadding: Bool = false) -> String {
        return String(format: "¥%@", NSNumber.priceString(fromFloat: self, addPadding: addPadding))
    }
}

extension NumberFormatter {
    static var feedListPriceFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }
    
    func string(fromDouble num: Double) -> String? {
        return string(from: NSNumber(value: num))
    }
}
