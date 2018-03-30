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
public let moneyLeftTableViewModelUpdate = "moneyLeftTableViewModelUpdate"
public let settingTableViewShowCategory = "settingTableViewShowCategory"
public let fixedCostDataListUpdata = "fixedCostDataListUpdata"
public let categoryDataListUpdata = "categoryDataListUpdata"

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











