/*
 Atomic.swift
 
 Copyright © 2019 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

// @MBDependency:2
/**
 多线程自动安全访问变量
 
 https://www.objc.io/blog/2018/12/18/atomic-variables/
 */
final class Atomic<A> {
    private lazy var queue = DispatchQueue(label: "Atomic value")
    private var _value: A
    init(_ value: A) {
        self._value = value
    }
    
    var value: A {
        get {
            return queue.sync { self._value }
        }
    }
    
    func mutate(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self._value)
        }
    }
}
