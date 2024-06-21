## 1. `PageStateItem` 协议
```swift
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
```

###  2.1 系统组件实现`PageStateItem`协议
```swift
// MARK: - 系统组件直接实现 PageStateItem 协议（不推荐）
// 为系统组件快速实现扩展，不实现的设置项使用默认值
// 不建议这么写
// 1. 会污染UILabel的命名空间
// 2. PageStateItem设置项无法重写为存储属性，无法在外部修改
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
    
    // 用存储属性实现，外部可修改
    var isScrollAllowed: Bool = false
    
    // 自定义快捷方法
    static func empty(text: String = "暂无数据") -> PSLabelItem {
        let label = PSLabelItem()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.text = text
        return label
    }
}`
```

### 2.2 自定义组件实现`PageStateItem`协议
实现一个简单的EmptyView，[SimpleEmptyView具体实现请查看Example](../Example/PageState/PageStateItem/SimpleEmptyView.swift)
```swift
typealias VoidTask = () -> Void

class SimpleEmptyView: BaseView, PageStateItem {
    // 省略部分代码
    // ...
    
    public func updateContent(_ type: EmptyType) {
        updateContent(type.image, text: type.description)
        
        switch type {
        case .networkError:
            // 网路错误，当容器为UIScrollView或其子类时，禁止滑动
            isScrollAllowed = false
        default:
            isScrollAllowed = true
        }
    }
    
    // 省略部分代码
    // ...
    
    // MARK: PageStateItem
    // 这一句可以不写，不写就是返回self
    var view: UIView { return self }  
    
    // 用存储属性实现，外部可修改
    var layoutStyle: PageStateLayoutStyle = .full(edgeInset: .zero)
    
    // 用存储属性实现，外部可修改
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
```

## 2. 给 View 设置`PageStateItem`

```swift
// 1
tableView.ps.item = PSLabelItem.empty(text: "加载中...")

// 2
let emptyView = SimpleEmptyView(.networkError)
// 点击刷新
emptyView.onTapViewClosure = { [weak sender, weak tableView] in
    // 重新触发网络请求...
}
tableView.ps.item = emptyView

//3
tableView.ps.item = SimpleEmptyView(.noContent)

// 4. 移除状态视图
tableView.ps.item = nil
```

## 3. UITableView、UICollectionView 扩展
```swift
// 内会调用 tableView.reloadData()
// 同时会刷新状态视图，当 tableView 有数据时自动隐藏
tableView.ps.reloadData()

collectionView.ps.reloadData()
```

