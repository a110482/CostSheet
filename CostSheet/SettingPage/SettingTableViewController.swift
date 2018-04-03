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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePresentMode = .categort
        reloadTableView(commandFrom: tablePresentMode)
        NotificationCenter.default.addObserver(forName: Notification.Name(settingTableDataListUpdata), object: nil, queue: OperationQueue.main) {[weak self] (_) in
            self?.reloadTableView(commandFrom:.categort)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tablePresentMode {
        case .categort:
            return model.settingTableDataList.count
        case .fixedCost:
            return model.settingTableDataList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var basicCellData = model.settingTableDataList[indexPath.row]
        let basicCell:BasicSettingCell
        
        // 根據狀況給予不同的cell
        switch tablePresentMode {
        case .categort:
            basicCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewFixedCostCell") as! SettingTableViewCategoryCell
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
    
    func reloadTableView(commandFrom mode:TableViewPresentMode){
        if tablePresentMode == mode{
            tableView.reloadData()
        }
    }
}






