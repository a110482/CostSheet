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
    var settingTableDataList = Array<BasicCellData>(){
        didSet{
            NotificationCenter.default.post(Notification(name: Notification.Name(settingTableDataListUpdata)))
        }
    }

    
    // MARK: 關於“分類”的函數
    // 刷新所有“分類”項目下的資料
    func updataAllCategoryDataFromDatabase(){
        let database = SQL()
        let cellData = database!.getAllCategoryData()
        settingTableDataList = cellData
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
    var terms:String            // 次要項目 （ 例如服飾分類下的“鞋子”
}









