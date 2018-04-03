//
//  SettingTableViewModel.swift
//  CostSheet
//
//  Created by elijah on 2018/3/21.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import SQLite

class SettingTableViewModel{
    // 儲存“分類”的資料
    var categoryDataList = Array<SettingTableViewCategoryCellData>(){
        didSet{
            NotificationCenter.default.post(Notification(name: Notification.Name(categoryDataListUpdata)))
        }
    }
    
    // 儲存“固定開銷”的資料
    var fixedCostDataList = Array<SettingTableViewFixedCostCellData>(){
        didSet{
            NotificationCenter.default.post(Notification(name: Notification.Name(fixedCostDataListUpdata)))
        }
    }
    
    // MARK: 關於“分類”的函數
    // 刷新所有“分類”項目下的資料
    func updataAllCategoryDataFromDatabase(){
        let database = SQL()
        let cellData = database!.getAllCategoryData()
        categoryDataList = cellData
    }
    
}

protocol BasicCellData{
    var databaseId:Int{get set}
    var category:String{get set}
    var index:Int{get set}
    var costSheet:Double{get set}
    var moneyUnit:String{get set}
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
    var terms:String
}









