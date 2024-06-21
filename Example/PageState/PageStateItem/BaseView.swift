//
//  BaseView.swift
//  PageState_Example
//
//  Created by zhaoshouwen on 2024/6/21.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

open class BaseView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
        configureConstraints()
    }

    open override func awakeFromNib() {
        configureSubviews()
        configureConstraints()
    }

    open func configureSubviews() {}
    open func configureConstraints() {}
}
