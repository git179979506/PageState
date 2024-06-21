//
//  SimpleEmptyView.swift
//  PageState_Example
//
//  Created by zhaoshouwen on 2024/6/21.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import PageState

typealias VoidTask = () -> Void

class SimpleEmptyView: BaseView, PageStateItem {
    public var onTapViewClosure: VoidTask?
    
    public var topOffset: CGFloat = 120 {
        didSet {
            stackView.snp.updateConstraints {
                $0.top.equalToSuperview().offset(topOffset)
            }
        }
    }
    
    public convenience init(_ type: EmptyType) {
        self.init()
        updateContent(type)
    }
    
    public func updateContent(_ type: EmptyType) {
        updateContent(type.image, text: type.description)
        
        switch type {
        case .networkError:
            isScrollAllowed = false
        default:
            isScrollAllowed = true
        }
    }
    
    public func updateContent(_ image: UIImage? = nil, text: String? = nil) {
        label.text = text
        label.isHidden = text == nil
        imageView.image = image
        imageView.isHidden = image == nil
    }

    override open func configureSubviews() {
        backgroundColor = UIColor.clear

        addSubview(stackView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapView))
        addGestureRecognizer(tap)
    }

    override open func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topOffset)
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview()
        }
    }
    
    @objc func onTapView() {
        onTapViewClosure?()
    }
    
    lazy var stackView: UIStackView =  {
        let stackVIew = UIStackView(arrangedSubviews: [imageView, label])
        stackVIew.axis = .vertical
        stackVIew.spacing = 20
        stackVIew.distribution = .equalCentering
        stackVIew.isUserInteractionEnabled = false
        return stackVIew
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var imageView = UIImageView()
    
    // MARK: - PageStateItem
    // 这一句可以不写，不写就是返回self
//    var view: UIView { return self }
    
    // 用存储属性实现，外部可修改
    var layoutStyle: PageStateLayoutStyle = .full(edgeInset: .zero)
    
    var fadeInOnDisplay: Bool = true
    var isTouchAllowed: Bool = true
    var isScrollAllowed: Bool = false
}

extension SimpleEmptyView {
    enum EmptyType {
        case networkError
        case noContent
        case custom(image: String?, desription: String)
        
        var image: UIImage? {
            switch self {
            case .networkError:
                return UIImage(named: "default_no_signal")
            case .custom(let name, _):
                return UIImage(named: name ?? "default_empty")
            default:
                return UIImage(named: "default_empty")
            }
        }
        
        var description: String? {
            switch self {
            case .noContent:
                return "还没有发现内容"
            case .networkError:
                return "网络不给力，轻触屏幕刷新"
            case .custom(_, let desc):
                return desc
            }
        }
    }
}
