//
//  CustomAlert.swift
//  CostSheet
//
//  Created by elijah on 2018/4/5.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import UIKit

struct CustomAlert {
    static func addNewCategory(presentOn targetVC:UIViewController){
        let alert = UIAlertController(title: "建立新類別", message: nil, preferredStyle: .alert)
        alert.addTextField { (textF) in
            textF.placeholder = "新分類"
        }
        alert.addTextField { (textF) in
            textF.placeholder = "預算額度"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert](_) in
            if checkTextVaild(text: alert?.textFields![0].text, targetVC:targetVC) && checkDoubleVaild(text: alert?.textFields![1].text, targetVC:targetVC){
                SQL()?.createNewCategory(
                    category: alert!.textFields![0].text!,
                    costSheet: Double(alert!.textFields![1].text!)!,
                    complete: nil
                )
            }
        }))
        targetVC.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: suport func
    // 檢查文字是否有效 移除空格並防止nil值
    static func checkTextVaild(text:String?, targetVC:UIViewController) -> Bool{
        if let _ = text, text!.replacingOccurrences(of: " ", with: "") != ""{
            return true
        }
        else{
            let alert = UIAlertController(title: "錯誤", message: "字串不可為空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            targetVC.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    // 檢查文字是否能轉換為浮點數
    static func checkDoubleVaild(text:String?, targetVC:UIViewController) -> Bool{
        if let _ = text , let _ = Double(text!.replacingOccurrences(of: " ", with: "")){
            return true
        }
        else{
            let alert = UIAlertController(title: "錯誤", message: "數字格式錯誤", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            targetVC.present(alert, animated: true, completion: nil)
            return false
        }
    }
}





