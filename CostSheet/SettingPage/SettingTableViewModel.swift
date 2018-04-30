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
        let database = SQL.singleton
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

protocol SettingTableViewFixedCostCellDataDelegate {
    func showDetailModeChanged(databaseId:Int)
}
struct SettingTableViewFixedCostCellData:BasicCellData {
    enum showDetailModeType:Int {
        case timesLeft = 0      // 剩餘幾期要繳
        case moneyLeft = 1     // 剩餘總金額
        case lastPaidDay = 2   // 最後一期付款日
        case remainingNumberOfDays = 3      // 距離最後一天付款日還有多久
    }
    var databaseId:Int
    var category:String
    var index:Int
    var costSheet:Double
    var moneyUnit:String
    var terms:String            // 次要項目 （ 例如服飾分類下的“鞋子”
    var expirationDate:Date
    var payData:Int
    var isPaid:Bool
    var detail:String{
        get{
            return self.getShowDetailString()
        }
    }
    var delegate:SettingTableViewFixedCostCellDataDelegate?
    init(databaseId:Int,
         category:String,
         index:Int,
         costSheet:Double,
         moneyUnit:String,
         terms:String,
         expirationDate:Date,
         payData:Int,
         isPaid:Bool
        ){
        self.databaseId = databaseId
        self.category = category
        self.index = index
        self.costSheet = costSheet
        self.moneyUnit = moneyUnit
        self.terms = terms
        self.expirationDate = expirationDate
        self.payData = payData
        self.isPaid = isPaid
    }
    private var showDetailMode:showDetailModeType?   // 此屬性請用函數存取
    
    // MARK: interface
    func getShowDetailString() -> String{ // FIXME:補完啊！！！
        let type = showDetailMode ?? .timesLeft
        switch type {
        case .timesLeft:
            return ""
        case .moneyLeft:
            return ""
        case .lastPaidDay:
            return ""
        case .remainingNumberOfDays:
            return ""
        }
    }

    func getShowDetailModeSQLCode() -> Int{
        return showDetailMode?.rawValue ?? 0
    }

    mutating func setShowDetailMode(by SQLCode:Int){
        showDetailMode = showDetailModeType(rawValue: SQLCode)
        delegate?.showDetailModeChanged(databaseId: databaseId)
    }
    
    mutating func setShowDetailMode(by type:showDetailModeType){
        showDetailMode = type
        delegate?.showDetailModeChanged(databaseId: databaseId)
    }
    
}









