//
//  Array+App.swift
//  ZNArt
//
//  Created by BB9z on 2018/5/28.
//  Copyright © 2018 znart.com. All rights reserved.
//

extension Array {
    
    /// 安全的获取元素，index 超出范围返回 nil
    func rf_object(at index: Int) -> Element? {
        if 0..<count ~= index {
            return self[index]
        }
        return nil
    }
}
