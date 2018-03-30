//
//  SettingViewController.swift
//  CostSheet
//
//  Created by elijah on 2018/3/20.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import UIKit

enum TableViewPresentMode{
    case categort
    case fixedCost
}
class SettingViewController:UIViewController{
    
    var tablePresentMode = TableViewPresentMode.categort
    
    @IBAction func setCategory(_ sender: Any) {
        
    }
    @IBAction func setFixedCost(_ sender: Any) {
    }
    @IBAction func removeItem(_ sender: Any) {
    }
    @IBAction func addItem(_ sender: Any) {
        if tablePresentMode == .categort{
            let alert = UIAlertController(title: "建立新類別", message: nil, preferredStyle: .alert)
            alert.addTextField { (textF) in
                textF.placeholder = "新分類"
            }
            alert.addTextField { (textF) in
                textF.placeholder = "預算額度"
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert](_) in
                if self.checkTextVaild(text: alert?.textFields![0].text) && self.checkDoubleVaild(text: alert?.textFields![1].text){
                    SQL()?.createNewCategory(
                        category: alert!.textFields![0].text!,
                        costSheet: Double(alert!.textFields![1].text!)!
                    )
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    @IBAction func upItem(_ sender: Any) {
    }
    @IBAction func downItem(_ sender: Any) {
    }
    
    
    // MARK: suport func
    // 檢查文字是否有效
    func checkTextVaild(text:String?) -> Bool{
        if let _ = text, text!.replacingOccurrences(of: " ", with: "") != ""{
            return true
        }
        else{
            let alert = UIAlertController(title: "錯誤", message: "字串不可為空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    // 檢查文字是否能轉換為數字
    func checkDoubleVaild(text:String?) -> Bool{
        if let _ = text , let _ = Double(text!.replacingOccurrences(of: " ", with: "")){
            return true
        }
        else{
            let alert = UIAlertController(title: "錯誤", message: "數字格式錯誤", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    } 
}








