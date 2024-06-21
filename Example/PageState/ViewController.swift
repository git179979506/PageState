//
//  ViewController.swift
//  PageState
//
//  Created by zhaoshouwen on 06/21/2024.
//  Copyright (c) 2024 zhaoshouwen. All rights reserved.
//

import UIKit
import PageState

class ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var cellCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.ps.item = PSLabelItem.empty(text: "加载中...")
    }
    
    @IBAction func onTapSegmentedControl(_ sender: UISegmentedControl) {
        cellCount = 0
        
        switch sender.selectedSegmentIndex {
        case 0: // 加载中
            tableView.ps.item = PSLabelItem.empty(text: "加载中...")
        case 1: // 无网络
            let emptyView = SimpleEmptyView.view(.networkError)
            // 点击刷新
            emptyView.onTapViewClosure = { [weak sender, weak tableView] in
                sender?.selectedSegmentIndex = 0
                tableView?.ps.item = PSLabelItem.empty(text: "加载中...")
            }
            tableView.ps.item = emptyView
        case 2: // 空数据
            tableView.ps.item = SimpleEmptyView.view(.noContent)
        default: // 有数据
            cellCount = 20
            
            // 调用 tableView.ps.reloadData() 刷新 tableView 数据时，有数据会自动隐藏 ps.item，下面这句可以省略
            // 调用 tableView.reloadData() 时不能省略
//             tableView.ps.item = nil
        }
        
        tableView.ps.reloadData()
        
//        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ns.dequeueCell(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = "这是第 \(indexPath.row) 个cell"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

