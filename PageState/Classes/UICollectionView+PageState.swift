//
//  UICollectionView+PageState.swift
//  test
//
//  Created by zsw on 2018/12/11.
//  Copyright © 2018 zsw. All rights reserved
//

import UIKit

private var pageStateItemKey: Void?
extension PageState where Base: UICollectionView {
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
    
    /// 刷新 page state 和 collection view
    public func reloadData() {
        reload()
        base.reloadData()
    }
    
    func reload() {
        let view = pageStateView
        
        if let item = item, itemsCount == 0 || item.shouldBeForcedToDisplay {
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
    
    var itemsCount: Int {
        var items = 0
        var sections = 1
        
        if let dataSource = base.dataSource {
            if dataSource.responds(to: #selector(UICollectionViewDataSource.numberOfSections(in:))) {
                sections = dataSource.numberOfSections!(in: base)
            }
            if dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:numberOfItemsInSection:))) {
                for i in 0 ..< sections {
                    items += dataSource.collectionView(base, numberOfItemsInSection: i)
                }
            }
        }
        return items
    }
}
