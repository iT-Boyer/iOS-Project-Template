//
//  MBSwift.swift
//  ZNArt
//
//  Created by BB9z on 2018/5/17.
//  Copyright © 2018 znart.com. All rights reserved.
//

import Foundation

/// Swift 对象与指针间的转换，对标 Objective-C 中的 __bridge 转换
/// REF: https://stackoverflow.com/a/33310021/945906

func __bridge<T : AnyObject>(obj : T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

func __bridge<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

func __bridge_retained<T : AnyObject>(obj : T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
}

func __bridge_transfer<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
}
