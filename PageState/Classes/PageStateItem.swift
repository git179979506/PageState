//
//  PageStateItem.swift
//  PageState
//
//  Created by zhaoshouwen on 2024/6/21.
//

import UIKit

/// PageStateItem 在容器中的布局方式
public enum PageStateLayoutStyle {
    /// 居中，要求状态视图自约束宽高
    /// - Parameter offset: 偏移量
    case center(offset: CGPoint)
    /// 撑满容器
    /// - Parameter edgeInset: 边缘填充
    case full(edgeInset: UIEdgeInsets)
    /// 自定义布局
    /// - Parameter layoutClosure: 布局回调，参数1：PageStateView，参数2：customView
    case custom(layoutClosure: (UIView, UIView) -> Void)
}

public protocol PageStateItem {
    /// 状态视图
    var view: UIView { get }
    /// 在容器中的布局方式，默认 `.full(edgeInset: .zero)`
    var layoutStyle: PageStateLayoutStyle { get }
    /// 是否强制展示，默认 false
    var shouldBeForcedToDisplay: Bool { get }
    /// 是否淡入展示，默认 true
    var fadeInOnDisplay: Bool { get }
    /// 状态视图是否允许点击，默认 false
    var isTouchAllowed: Bool { get }
    /// 当容器为ScrollView时，是否允许滚动，默认 false
    var isScrollAllowed: Bool { get }
}

extension PageStateItem {
    public var layoutStyle: PageStateLayoutStyle { return PageStateLayoutStyle.full(edgeInset: .zero) }
    
    public var shouldBeForcedToDisplay: Bool { return false }
    public var fadeInOnDisplay: Bool { return true }
    public var isTouchAllowed: Bool { return false }
    public var isScrollAllowed: Bool { return false }
    
    public func config(callback: (Self) -> Void) -> Self {
        callback(self)
        return self
    }
}

extension PageStateItem where Self: UIView {
    public var view: UIView { return self }
}

