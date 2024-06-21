//
//  NameSpace.swift
//  PageState_Example
//
//  Created by zhaoshouwen on 2024/6/21.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public struct NameSpace<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

public protocol NameSpaceCompatible {
    associatedtype NameSpaceBase
    
    static var ns: NameSpace<NameSpaceBase>.Type { get set }
    
    var ns: NameSpace<NameSpaceBase> { get set }
}

extension NameSpaceCompatible {
    public static var ns: NameSpace<Self>.Type {
        get {
            return NameSpace<Self>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base type
        }
    }

    /// Reactive extensions.
    public var ns: NameSpace<Self> {
        get {
            return NameSpace(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}

extension UIView: NameSpaceCompatible { }
