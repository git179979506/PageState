//
//  UITableView+reuse.swift
//  PageState_Example
//
//  Created by zhaoshouwen on 2024/6/21.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

private var kCellRegisterTable: Void?
private var kHeaderFooterRegisterTable: Void?

// MARK: 注册复用
extension NameSpace where Base: UITableView {
    
    /// 免注册复用cell，未注册时会自动注册，并记录到cellRegisterTable
    public func dequeueCell<T: UITableViewCell>(_ className: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: className)
        if !base.cellRegisterTable.contains(identifier) {
            register(cell: className)
        }
        guard let cell = base.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            assertionFailure("Couldn't find UITableViewCell for \(identifier)")
            return T(style: .default, reuseIdentifier: identifier)
        }
        return cell
    }
    
    /// 免注册复用header footer view，未注册时会自动注册，并记录到headerFooterRegisterTable
    public func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ className: T.Type) -> T {
        let identifier = String(describing: className)
        if !base.headerFooterRegisterTable.contains(identifier) {
            register(headerFooter: className)
        }
        guard let headerFooterView = base.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            assertionFailure("Couldn't find UITableViewHeaderFooterView for \(identifier)")
            return T(reuseIdentifier: identifier)
        }
        return headerFooterView
    }
    
    /// 注册header footer view，记录到headerFooterRegisterTable
    public func register<T: UITableViewHeaderFooterView>(headerFooter className: T.Type) {
        let identifier = String(describing: className)
        base.headerFooterRegisterTable.insert(identifier)
        base.register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    /// 注册cell，记录到cellRegisterTable
    public func register<T: UITableViewCell>(cell className: T.Type) {
        let identifier = String(describing: className)
        base.cellRegisterTable.insert(identifier)
        base.register(T.self, forCellReuseIdentifier: identifier)
    }
}

private extension UITableView {
    var cellRegisterTable: Set<String> {
        get {
            if let table = objc_getAssociatedObject(self, &kCellRegisterTable) as? Set<String> {
                return table
            } else {
                objc_setAssociatedObject(self, &kCellRegisterTable, Set<String>(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return []
            }
        }
        set {
            objc_setAssociatedObject(self, &kCellRegisterTable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var headerFooterRegisterTable: Set<String> {
        get {
            if let table = objc_getAssociatedObject(self, &kHeaderFooterRegisterTable) as? Set<String> {
                return table
            } else {
                objc_setAssociatedObject(self, &kHeaderFooterRegisterTable, Set<String>(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return []
            }
        }
        set {
            objc_setAssociatedObject(self, &kHeaderFooterRegisterTable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

