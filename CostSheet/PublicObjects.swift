//
//  PublicObjects.swift
//  CostSheet
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//
import Foundation

// MARK: 普通公用變數
public let moneyUnitSymbl = Locale.current.currencySymbol   // 貨幣單位

// MARK: 通知中心監聽鍵值
public let moneyLeftTableViewModelUpdate = "moneyLeftTableViewModelUpdate"  // 預算金額頁面 模型有變動
//public let settingTableViewShowCategory = "settingTableViewShowCategory"    //
public let settingTableDataListUpdata = "settingTableDataListUpdata"        // 設定頁面的資料array變動
public let catagorySQLChanged = "catagorySQLChanged"                    // “分類”SQL 資料變動

// MARK: extension
// 若小數點後無數字，不顯示小數點
extension Double{
    func tryToCutDotString() -> String{
        let selfInt = Int(self)
        if self - Double(selfInt) == 0{
            return String(selfInt)
        }
        else{
            return String(self)
        }
    }
}











