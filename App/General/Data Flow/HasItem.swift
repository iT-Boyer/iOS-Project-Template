/*
 HasItem.swift

 Copyright © 2020 BB9z.
 https://github.com/BB9z/iOS-Project-Template

 The MIT License
 https://opensource.org/licenses/MIT
 */

import Foundation

/// 定义通用的模型属性，便于对象间传值
protocol HasItem: AnyHasItem {
    associatedtype Item

    /**
     item 模型属性

     一般传值发生在 init 后，且正常不为 nil
     Swift protocol 对是否为空限制严格，只有这种形式满足实际使用需要
     */
    var item: Item! { get set }
}

/**
 HasItem type erasure
 与常规的用包装消除类型不同，这里需要消除协议自身及其 associated type 的类型约束
 */
protocol AnyHasItem {
    /// 读取 item，类型不匹配转为 nil
    func item<T>() -> T?

    /// 设置 item，必须是类型匹配的非空值
    mutating func setItem<T>(_ item: T)
}

extension HasItem {
    func item<T>() -> T? {
        // 实现备忘：
        // item 正常是非空（未赋值肯定是 bug），这里如果返回非空，外面用起来会方便点
        // 但类型不匹配也是常见 bug，不如用 Optional 始终保持警惕的做法省心
        // 另外，根据编译环境区分处理不合适
        item as? T
    }
    mutating func setItem<T>(_ item: T) {
        guard let newValue = item as? Item else {
            fatalError("set item type mismatched.")
        }
        self.item = newValue
    }
}

extension UIViewController {
    /**
     通用 segue 传值辅助方法

     destination 需符合 AnyHasItem，item 依次尝试从 source、sender、sender 各级别父 view 直到 view controller 的 view

     使用需显式重载 prepare 方法，例：

     ```
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         generalPrepare(segue: segue, sender: sender)
     }
     ```
     */
    func generalPrepare(segue: UIStoryboardSegue, sender: Any?) {
        guard var destination = segue.destination as? AnyHasItem else {
            return
        }
        if let source = sender as? AnyHasItem,
           let item: Any = source.item() {
            destination.setItem(item)
            return
        }

        // 尝试从 sender 各个父 view 取
        if var view = sender as? UIView,
           view.viewController === self {
            while let superview = view.superview {
                view = superview
                if let source = view as? AnyHasItem,
                   let item: Any = source.item() {
                    destination.setItem(item)
                    return
                }
                if view === self.view { break }
            }
        }

        if let source = segue.source as? AnyHasItem,
           let item: Any = source.item() {
            destination.setItem(item)
        }
    }
}
