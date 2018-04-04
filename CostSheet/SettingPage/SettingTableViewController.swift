//
//  SettingTableViewController.swift
//  CostSheet
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import UIKit

// tabview 可能顯示兩種資料內容(categort or fixedCost) 但同時只會顯示一種
// cell 更新機制： 1. (資料庫變動 發送NotificationCenter 給model) 或是 (手動切換更新模式 由本ＶＣ要求model去SQL撈資料)
//               2. model 發送 NotificationCenter 通知 VC 資料有更新
//               3. 本ＶＣ 拷貝一份 資料的array到本地 然後加上一個“新增”的cell 再刷新頁面
class SettingTableViewController:UITableViewController{
    var tablePresentMode = TableViewPresentMode.categort{   // 記錄現在tableView的顯示內容是哪一種
        didSet{
            if tablePresentMode == .categort{
                model.updataAllCategoryDataFromDatabase()
            }
            else if tablePresentMode == .fixedCost{
                
            }
        }
    }
    let model = SettingTableViewModel()
    var settingTableDataList:Array<BasicCellData> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "PlusActionCell", bundle: nil)     // 具有“新增項目”功能的 cell
        tableView.register(nib, forCellReuseIdentifier: "PlusActionCell")
        NotificationCenter.default.addObserver(forName: Notification.Name(settingTableDataListUpdata), object: nil, queue: OperationQueue.main) {[weak self] (_) in
            self?.settingTableDataList = (self?.model.settingTableDataList)!
            self?.customReloadTableView()
        }
        tablePresentMode = .categort
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTableDataList.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < self.settingTableDataList.count else {
            return tableView.dequeueReusableCell(withIdentifier: "PlusActionCell")!
        }
        var basicCellData = settingTableDataList[indexPath.row]
        let basicCell:BasicSettingCell
        
        // 根據狀況給予不同的cell
        switch tablePresentMode {
        case .categort:
            basicCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCategoryCell") as! SettingTableViewCategoryCell
        case .fixedCost:
            basicCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewFixedCostCell") as! SettingTableViewFixedCostCell
        }
        
        // 先塞入共用資料
        basicCell.category.text = basicCellData.category
        basicCell.costSheet.text = basicCellData.costSheet.tryToCutDotString()
        
        // 再塞每種cell不同的資料
        if let categoryCell = basicCell as? SettingTableViewCategoryCell{
            return categoryCell
        }
        else if let fixedCostCell = basicCell as? SettingTableViewFixedCostCell{
            let fixedCostcellData = basicCellData as! SettingTableViewFixedCostCellData
            fixedCostCell.terms.text = fixedCostcellData.terms
            return fixedCostCell
        }
        else{
            return basicCell
        }
    }
    
    func customReloadTableView(){
        tableView.reloadData()
    }
    
}






