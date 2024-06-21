//
//  PageState.swift
//  KOS
//
//  Created by zsw on 2018/6/4.
//  Copyright © 2018年 HuaYun. All rights reserved.
//

import UIKit

// MARK: View
class PageStateView: UIView {
    
    var fadeInOnDisplay: Bool = false
    
    private(set) var customView: UIView? {
        willSet {
            if let customView = customView {
                customView.removeFromSuperview()
            }
        }
        didSet {
            if let customView = customView {
                addSubview(customView)
            }
        }
    }
    
    func setCoutomView(_ view: UIView?, layoutStyle: PageStateLayoutStyle) {
        if let view = view {
            customView = view
            view.translatesAutoresizingMaskIntoConstraints = false
            switch layoutStyle {
            case .center(let offset):
                view.center = center
                view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset.x).isActive = true
                view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: offset.y).isActive = true
            case .full(let edgeInset):
                view.frame = bounds.inset(by: edgeInset)
                view.topAnchor.constraint(equalTo: topAnchor, constant: edgeInset.top).isActive = true
                view.leftAnchor.constraint(equalTo: leftAnchor, constant: edgeInset.left).isActive = true
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -edgeInset.bottom).isActive = true
                view.rightAnchor.constraint(equalTo: rightAnchor, constant: -edgeInset.right).isActive = true
            case .custom(let layoutClosure):
                layoutClosure(self, view)
            }
        } else {
            customView = nil
        }
    }
    
    func prepareForReuse() {
        customView = nil
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView is UIControl {
            return hitView
        }
        
        if hitView == self || hitView == customView {
            return hitView
        }
        
        return nil
    }
    
    override func didMoveToSuperview() {
        let f = superview?.frame ?? .zero
        frame = CGRect(x: 0, y: 0, width: f.width, height: f.height)
        
        func fadeInClosure() {
            alpha = 1
        }
        
        if fadeInOnDisplay {
            alpha = 0
            UIView.animate(withDuration: 0.25, animations: fadeInClosure)
        } else {
            fadeInClosure()
        }
    }
}

// MARK: Item
class PageStateItemContainer {
    var item: PageStateItem?
    
    init(with item: PageStateItem?) {
        self.item = item
    }
}

// MARK: - Base
public struct PageState<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
    
    // 刷新
    func reload() { }
}

public protocol PageStateCompatible {
    associatedtype PageStateBase
    static var ps: PageState<PageStateBase>.Type { get set }
    var ps: PageState<PageStateBase> { get set }
}

extension PageStateCompatible {
    public static var ps: PageState<Self>.Type {
        get {
            return PageState<Self>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            
        }
    }
    
    public var ps: PageState<Self> {
        get {
            return PageState(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            
        }
    }
}

extension UIView: PageStateCompatible { }
