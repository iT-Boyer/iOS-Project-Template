/**
 应用级别的便捷方法
 */
extension Date {
    /// 毫秒时间戳
    var timestamp: Int64 {
        return Int64(timeIntervalSince1970 * 1000)
    }
    
    /// 一天的起始时间
    var dayStart: Date {
        return (self as NSDate).dayStart
    }
    
    /// 一天的结束时间
    var dayEnd: Date {
        return (self as NSDate).dayEnd
    }
    
    /// 刚刚、几分钟前、几小时前等样式
    var recentString: String {
        return (self as NSDate).recentString
    }
    
    /// 后台专用日期格式 yyyy-MM-dd
    var dayIdentifier: MBDateDayIdentifier {
        return DateFormatter.cachedDayIdentifier().string(from: self) as MBDateDayIdentifier
    }
}

extension TimeInterval {
    var mmssString: String {
        let value = Int(self.rounded())
        return String(format: "%02d:%02d", value/60,  value%60)
    }
}
