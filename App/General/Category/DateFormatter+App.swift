/*
 应用级别的便捷方法
 */
extension DateFormatter {
    
    /// MBDateDayIdentifier 专用格式化
    @objc static let dayIdentifier: DateFormatter = {
        let df = DateFormatter()
        df.timeZone = .server
        df.dateFormat = "yyyyMMdd"
        return df
    }()
    
    /// 本地化的 X年X月X日
    @objc static let localizedYMD: DateFormatter = {
        return DateFormatter.currentLocale(fromTemplate: "yMMMMd")
    }()
    
    /// 本地化的 X月X日
    @objc static let localizedMD: DateFormatter = {
        return DateFormatter.currentLocale(fromTemplate: "MMMMd")
    }()
    
    /// 本地化的周几
    @objc static let localizedShortWeek: DateFormatter = {
        return DateFormatter.currentLocale(fromTemplate: "EEEEE")
    }()
}
