/**
 应用级别的便捷方法
 */
extension Array {
    
    /// 非空，结合空的判断使用起来更容易些
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// 安全的获取元素，index 超出范围返回 nil
    func rf_object(at index: Int) -> Element? {
        if 0..<count ~= index {
            return self[index]
        }
        return nil
    }
    
    /**
     从数组中提取元素，这些元素会从数组中移除并返回
     
     例
     ```
     var a = [1, 2, 3, 4, 5, 6]
     print(a.extract { $0 < 3 })  // [1, 2]
     print(a)                     // [3, 4, 5, 6]
     ```
     */
    mutating func extract(while predicate: (Element) -> Bool) -> [Element] {
        var elementRemoved = [Element]()
        removeAll { e -> Bool in
            let shouldExtracted = predicate(e)
            if shouldExtracted {
                elementRemoved.append(e)
            }
            return shouldExtracted
        }
        return elementRemoved
    }
}

extension Array where Iterator.Element: Hashable {
    /// 返回去重的数组
    func uniqued() -> [Element] {
        return Array(Set<Element>(self))
    }
}

extension Array where Iterator.Element: UIView {
    /// 改变一组 view 的隐藏
    func views(hidden: Bool) {
        forEach { v in
            v.isHidden = hidden
        }
    }
}
