/*
 MBSwift.swift
 
 Copyright © 2018, 2020 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 
 Swift 语言扩展
 */

// Swift 对象与指针间的转换，对标 Objective-C 中的 __bridge 转换
// REF: https://stackoverflow.com/a/33310021/945906
// @MBDependency:1

// 允许方法名 __ 开头
// swiftlint:disable identifier_name

func __bridge<T: AnyObject>(obj: T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

func __bridge<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

func __bridge_retained<T: AnyObject>(obj: T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
}

func __bridge_transfer<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
}

// swiftlint:enable identifier_name

/// 语言辅助工具
enum MBSwift {

    /// 强转类型非空值
    ///
    /// - Parameters:
    ///   - obj: 必须非空，类型与 type 相符，否则终止运行
    ///   - type: 转换类型
    /// - Returns: 转换后的非空值
    static func cast<T>(_ obj: Any?, as type: T.Type) -> T {
        guard let instance = obj as? T else {
            fatalError("Cast object is nil or type mismatched.")
        }
        return instance
    }
}
