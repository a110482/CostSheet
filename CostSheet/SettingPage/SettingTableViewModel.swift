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
    
    var fixedCostDataList = Array<SettingTableViewFixedCostCellData>(){
        didSet{
            NotificationCenter.default.post(Notification(name: Notification.Name(fixedCostDataListUpdata)))
        }
    }
    
    
    
    
}

struct SettingTableViewCategoryCellData {
    var databaseId:Int
    var category:String
    var index:Int
    var costSheet:Double
    let moneyUnit = moneyUnitSymbl
}
struct SettingTableViewFixedCostCellData {
    
}









