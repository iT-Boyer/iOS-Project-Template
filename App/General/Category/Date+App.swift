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
    
    /// 后台专用日期格式
    var dayIdentifier: MBDateDayIdentifier {
        return DateFormatter.cachedDayIdentifier().string(from: self) as MBDateDayIdentifier
    }
    
    /**
     按当前历法判断两个可选日期在某一时间维度上是否一致
     
     都为 nil 会返回 true；2000-01-01 和 2000-05-01 在 .day，包括时分秒的维度上都是不一致的
     
     - parameter granularity: 比较的维度；比较的方式是纬度从大到小，指定维度以上都一样就算是一致；所以不会有传多个维度的场景
     */
    static func isSame(granularity: Calendar.Component, _ date1: Date?, _ date2: Date?) -> Bool {
        if date1 == nil && date2 == nil {
            return true
        }
        guard let date1 = date1, let date2 = date2 else {
            return false
        }
        return Calendar.current.compare(date1, to: date2, toGranularity: granularity) == .orderedSame
    }
}

extension TimeInterval {
    /// XX:XX 时长显示，超过一小时不显示小时
    var mmssString: String {
        let value = Int(self.rounded())
        return String(format: "%02d:%02d", value/60,  value%60)
    }
    
    /**
     按时长返回时分秒
     
     例
     ```
     print(TimeInterval(12345).durationComponents)
     // (hour: 3, minute: 25, second: 45)
     ```
     */
    var durationComponents: (hour: Int, minute: Int, second: Int) {
        var second = Int(self.rounded())
        let hour = second / 3600
        second -= hour * 3600
        let minute = second / 60
        second -= minute * 60
        return (hour, minute, second)
    }
}

extension TimeZone {
    /// 服务器时区
    static var server = TimeZone(identifier: "Asia/Shanghai")!
}
