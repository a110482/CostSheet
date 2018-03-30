//
//  MoneyLeftTableViewModel.swift
//  CostSheet
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation

class MoneyLeftTableViewModel{
    
    var tableViewData:Array<MoneyLeftTableCellData>{
        didSet{
            NotificationCenter.default.post(Notification(name: Notification.Name(moneyLeftTableViewModelUpdate)))
        }
    }
    // MARK: demo data
    init() {
        tableViewData = []
        let demo = MoneyLeftTableCellData(category: "衣服", moneyLeft: 5000)
        tableViewData.append(demo)
        tableViewData.append(MoneyLeftTableCellData(category: "吃飯", moneyLeft: 3000))
        tableViewData.append(MoneyLeftTableCellData(category: "喇妹", moneyLeft: 12000))
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.tableViewData.append(MoneyLeftTableCellData(category: "喇妹", moneyLeft: 12000))
        }
    }
    
    class MoneyLeftTableCellData:NSObject{
        var category:String
        var moneyLeft:Double
        var moneyUnit:String
        init(category:String, moneyLeft:Double){
            self.category = category
            self.moneyLeft = moneyLeft
            self.moneyUnit = moneyUnitSymbl ?? ""
        }
    }
}
