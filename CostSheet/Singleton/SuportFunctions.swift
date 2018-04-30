//
//  SuportFunctions.swift
//  CostSheet
//
//  Created by elijah on 2018/4/24.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
struct SuportFunctions{
    static let singleton = SuportFunctions()
    // 檢查文字是否有效 移除空格並防止nil值
    static func checkTextVaild(text:String?) -> Bool{
        if let _ = text, text!.replacingOccurrences(of: " ", with: "") != ""{
            return true
        }
        return false
    }
    
    // 檢查文字是否能轉換為浮點數
    static func checkDoubleVaild(text:String?) -> Bool{
        if let _ = text , let _ = Double(text!.replacingOccurrences(of: " ", with: "")){
            return true
        }
        return false
    }
    
    
}











