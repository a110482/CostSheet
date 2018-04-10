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
    init(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(catagorySQLChanged), object: nil, queue: .main) { [weak self](_) in
            self?.updataAllCategoryDataFromDatabase()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(fixedCostSQLChanged), object: nil, queue: .main) { [weak self](_) in
            self?.updataAllFixedCostDataFromDatabase()
        }
    }
    
    // MARK: - variable
    // 儲存“分類”的資料
    private var settingCatagoryTableDataList = Array<SettingTableViewCategoryCellData>(){
        didSet{
            NotificationCenter.default.post(Notification(name: Notification.Name(settingTableCatagoryDataListUpdata)))
        }
    }
    private var settingFixedCostTableDataList = Array<SettingTableViewFixedCostCellData>(){
        didSet{
            NotificationCenter.default.post(Notification(name: Notification.Name(settingTableFixedCostDataListUpdata)))
        }
    }

    // MARK: - interface
    func getSettingCatagoryTableDataList() -> Array<SettingTableViewCategoryCellData>{
        return settingCatagoryTableDataList
    }
    func getSettingFixedCostTableDataList() -> Array<SettingTableViewFixedCostCellData>{
        return settingFixedCostTableDataList
    }
    
    // MARK: - private function
    // 刷新所有“分類”項目下的資料
    private func updataAllCategoryDataFromDatabase(){
        let database = SQL.singletom
        let cellData = database!.getAllCategoryData()
        settingCatagoryTableDataList = cellData
    }
    // 刷新所有“固定開銷”項目下所有資料
    private func updataAllFixedCostDataFromDatabase(){
        settingFixedCostTableDataList = []
    }
    
}
// MARK: - cell Data 的格式
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









