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
        NotificationCenter.default.addObserver(forName: Notification.Name(categoryDataListUpdata), object: nil, queue: OperationQueue.main) {[weak self] (_) in
            self?.reloadTableView(commandFrom:.categort)
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(fixedCostDataListUpdata), object: nil, queue: OperationQueue.main) {[weak self] (_) in
            self?.reloadTableView(commandFrom:.fixedCost)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tablePresentMode {
        case .categort:
            return model.categoryDataList.count
        case .fixedCost:
            return model.fixedCostDataList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BasicCellData
        switch tablePresentMode {
        case .categort:
            let cellData = model.categoryDataList[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewFixedCostCell") as! SettingTableViewCategoryCell    
        case .fixedCost:
            let cellData = model.fixedCostDataList[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewFixedCostCell") as! SettingTableViewFixedCostCell
            cell.category.text = cellData.category
            cell.costSheet.text = cellData.costSheet.tryToCutDotString()
            cell.terms.text = cellData.terms
            return cell
        }
        cell.category.text = cellData.category
        cell.costSheet.text = cellData.costSheet.tryToCutDotString()
        return cell
    }
    
    func reloadTableView(commandFrom mode:TableViewPresentMode){
        if tablePresentMode == mode{
            tableView.reloadData()
        }
    }
}

// cell Data 的格式
protocol BasicCellData{
    var databaseId:Int{get set}     // 位於資料庫的pk值
    var category:String{get set}     // 分類 
    var index:Int{get set}          // cell 顯示的順序
    var costSheet:Double{get set}    // 預算花費金額
    var moneyUnit:String{get set}    // 金額單位 美金台幣之類的
}
struct SettingTableViewCategoryCellData:BasicCellData {
    var databaseId:Int
    var category:String
    var index:Int
    var costSheet:Double
    var moneyUnit:String
}
struct SettingTableViewFixedCostCellData:BasicCellData {
    var databaseId:Int
    var category:String
    var index:Int
    var costSheet:Double
    var moneyUnit:String
    var terms:String            // 次要項目 （例如 服飾分類下的“鞋子”
}





