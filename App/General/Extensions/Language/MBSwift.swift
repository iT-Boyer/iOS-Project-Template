/*
 MBSwift.swift
 
 Copyright © 2018 RFUI.
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
