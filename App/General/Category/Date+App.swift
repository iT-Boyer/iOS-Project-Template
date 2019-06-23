/*
 应用级别的便捷方法
 */
extension Date {
    
    // @MBDependency:2
    /// 毫秒时间戳
    var timestamp: Int64 {
        return Int64(timeIntervalSince1970 * 1000)
    }
    
    // @MBDependency:2
    /// 一天的起始时间
    var dayStart: Date {
        return (self as NSDate).dayStart
    }
    
    // @MBDependency:2
    /// 一天的结束时间
    var dayEnd: Date {
        return (self as NSDate).dayEnd
    }
    
    /// 后台专用日期格式
    var dayIdentifier: MBDateDayIdentifier {
        return DateFormatter.dayIdentifier.string(from: self) as MBDateDayIdentifier
    }
    
    // @MBDependency:3
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
    
    // @MBDependency:2 范例性质，请根据项目需求修改
    /**
     今天，则“今天”
     今年，则本地化的 X月X日
     再久，本地化的 X年X月X日
     */
    var dayString: String {
        if Date.isSame(granularity: .day, self, Date()) {
            return "今天"
        }
        else if Date.isSame(granularity: .year, self, Date()) {
            return DateFormatter.localizedMD.string(from: self)
        }
        else {
            return DateFormatter.localizedYMD.string(from: self)
        }
    }

    // @MBDependency:2 范例性质，请根据项目需求修改
    /// 刚刚、几分钟前、几小时前等样式
    var recentString: String {
        let diff = -timeIntervalSinceNow
        if diff < 3600 * 24 {
            if diff < 60 {
                return "刚刚"
            }
            let hour = Int(diff / 3600)
            if hour < 1 {
                return "\(Int(diff / 60))分钟前"
            }
            return "\(hour)小时前"
        }
        else if diff < 3600 * 24 * 30 {
            let diffDay = NSDate.daysBetweenDate(self, andDate: Date())
            return "\(diffDay)天前"
        }
        return dayString
    }
}

extension TimeInterval {
    // @MBDependency:3
    /// XX:XX 时长显示，超过一小时不显示小时
    var mmssString: String {
        let value = Int(self.rounded())
        return String(format: "%02d:%02d", value/60,  value%60)
    }
    
    // @MBDependency:2
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
    // @MBDependency:2
    /// 服务器时区
    static var server = TimeZone(identifier: "Asia/Shanghai")!
}
