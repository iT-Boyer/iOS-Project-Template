/*!
 String+App.swift
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
import Foundation

extension String {
    
    /// 非空，结合空的判断使用起来更容易些
    var isNotEmpty: Bool {
        return !isEmpty
    }

    /// 应用级别行为，输入预处理，
    func trimmed() -> String? {
        let rs = trimmingCharacters(in: .whitespaces)
        return rs.isNotEmpty ? rs : nil
    }
}
