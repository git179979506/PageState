//
//  UILable+ps.swift
//  PageState_Example
//
//  Created by zhaoshouwen on 2024/6/21.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import PageState

// MARK: - 系统组件直接实现 PageStateItem 协议（不推荐）
// 为系统组件快速实现扩展，不实现的设置项使用默认值
// 不建议这么写
// 1. 会污染UILabel的命名空间
// 2. 无法PageStateItem设置项无法重写为存储属性，无法在外部修改
//extension UILabel: PageStateItem { 
//    // 布局改为居中，UILabel可以自约束宽高
//    public var layoutStyle: PageStateLayoutStyle {
//        return .center(offset: .zero)
//    }
//}

// MARK: - 子类化
class PSLabelItem: UILabel, PageStateItem {
    // 布局改为居中，UILabel可以自约束宽高
    // 时候用计算属性，不让外部修改
    public var layoutStyle: PageStateLayoutStyle {
        return .center(offset: .zero)
    }
    
    // 重写为存储属性，外部可修改
    var isScrollAllowed: Bool = false
    
    // 自定义快捷方法
    static func empty(text: String = "暂无数据") -> PSLabelItem {
        let label = PSLabelItem()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.text = text
        return label
    }
}
