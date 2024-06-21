//
//  UIView+PageState.swift
//  test
//
//  Created by zsw on 2018/12/11.
//  Copyright © 2018 zsw. All rights reserved.
//

import UIKit

private var pageStateItemKey: Void?
private var pageStateViewKey: Void?

extension PageState where Base: UIView {
    
    var pageStateView: PageStateView {
        let frame = CGRect(x: 0, y: 0, width: base.frame.width, height: base.frame.height)
        if let view = objc_getAssociatedObject(base, &pageStateViewKey) as? PageStateView {
            view.frame = frame
            return view
        } else {
            let view = PageStateView(frame: frame)
            view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.isHidden = true
            objc_setAssociatedObject(base, &pageStateViewKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
    }
    
    public var item: PageStateItem? {
        get {
            return getItem()
        }
        set {
            setItem(newValue)
            reload()
        }
    }
    
    func reload() {
        let view = pageStateView
        if let item = item {
            view.fadeInOnDisplay = item.fadeInOnDisplay
            if view.superview == nil {
                base.addSubview(view)
            }
            
            view.prepareForReuse()
            
            view.setCoutomView(item.view, layoutStyle: item.layoutStyle)
            
            view.isHidden = false
            view.clipsToBounds = true
            view.isUserInteractionEnabled = item.isTouchAllowed
            
            UIView.performWithoutAnimation {
                view.layoutIfNeeded()
            }
        } else if view.isHidden == false {
            view.isHidden = true
            view.prepareForReuse()
            view.removeFromSuperview()
        }
    }
    
    func getItem() -> PageStateItem? {
        let container = objc_getAssociatedObject(base, &pageStateItemKey) as? PageStateItemContainer
        return container?.item
    }
    
    func setItem(_ item: PageStateItem?) {
        if let newValue = item {
            let container = PageStateItemContainer(with: newValue)
            objc_setAssociatedObject(base, &pageStateItemKey, container, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else {
            objc_setAssociatedObject(base, &pageStateItemKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
