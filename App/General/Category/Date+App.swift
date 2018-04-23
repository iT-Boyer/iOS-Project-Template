/*!
 Date+App.swift
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

import Foundation

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
}
