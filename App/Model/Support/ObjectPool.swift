/*
 ObjectPool.swift

 Copyright © 2021 BB9z.
 https://github.com/BB9z/iOS-Project-Template

 The MIT License
 https://opensource.org/licenses/MIT
 */

/**
 弱引用存储 model 实例，用于保证相同 id 的对象有唯一实例，线程安全

 项目模版的 model 更新后刷新机制依赖 model 实例的唯一性
 */
final class ObjectPool<Key: Hashable, Value: AnyObject> {
    private lazy var store = [Key: Weak]()
    private lazy var lock = NSLock()

    init() {
    }

    subscript(index: Key) -> Value? {
        get {
            lock.lock()
            let value = store[index]
            lock.unlock()
            return value?.object
        }
        set {
            lock.lock()
            store[index] = Weak(object: newValue)
            lock.unlock()
        }
    }

    func removeAll() {
        lock.lock()
        store.removeAll()
        lock.unlock()
    }

    private struct Weak {
        weak var object: Value?
    }
}
