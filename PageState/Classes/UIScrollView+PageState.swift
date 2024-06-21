//
//  UIScrollView+PageState.swift
//  test
//
//  Created by zsw on 2018/12/11.
//  Copyright © 2018 zsw. All rights reserved.
//

import UIKit

private var pageStateItemKey: Void?
private var isScrollEnabledKey: Void?
extension PageState where Base: UIScrollView {
    public var item: PageStateItem? {
        get {
            return getItem()
        }
        set {
            cacheScrollEnabled()
            setItem(newValue)
            reload()
        }
    }
        
    func reload() {
        let view = pageStateView
        if let item = item {
            view.fadeInOnDisplay = item.fadeInOnDisplay
            if view.superview == nil {
                base.insertSubview(view, at: 0)
            }
            
            view.prepareForReuse()
            
            view.setCoutomView(item.view, layoutStyle: item.layoutStyle)
            
            view.isHidden = false
            view.clipsToBounds = true
            view.isUserInteractionEnabled = item.isTouchAllowed
            
            UIView.performWithoutAnimation {
                view.layoutIfNeeded()
            }
            
            base.isScrollEnabled = item.isScrollAllowed
        } else if view.isHidden == false {
            view.isHidden = true
            view.prepareForReuse()
            view.removeFromSuperview()
            
            base.isScrollEnabled = getScrollEnabled()
        } else {
            base.isScrollEnabled = getScrollEnabled()
        }
    }
    
    func getScrollEnabled() -> Bool {
        return objc_getAssociatedObject(base, &isScrollEnabledKey) as? Bool ?? false
    }
    
    func cacheScrollEnabled() {
        if item != nil {
            base.isScrollEnabled = getScrollEnabled()
        }
        objc_setAssociatedObject(base, &isScrollEnabledKey, base.isScrollEnabled, .OBJC_ASSOCIATION_ASSIGN)
    }
}
