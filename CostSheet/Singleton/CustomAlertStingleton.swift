//
//  CustomAlert.swift
//  CostSheet
//
//  Created by elijah on 2018/4/5.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import UIKit

struct CustomAlertStingleton {
    static let singleton = CustomAlertStingleton()
    
    // 新增“類別”
    static func addNewCategory() -> UIAlertController{
        let alert = UIAlertController(title: "建立新類別", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textF) in
            textF.placeholder = "新分類"
        }
        alert.addTextField { (textF) in
            textF.placeholder = "預算額度"
        }
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: {(_) in
            // 取得tabBarVC
            let appdelegate = UIApplication.shared.delegate
            let rootVC = appdelegate?.window!?.rootViewController as? LaunchViewController
            
            guard SuportFunctions.checkTextVaild(text: alert.textFields![0].text) else{
                rootVC?.tabBarViewController?.errorAlertString = "字串不可為空"
                return
            }
            guard SuportFunctions.checkDoubleVaild(text: alert.textFields![1].text) else {
                rootVC?.tabBarViewController?.errorAlertString = "數字格式錯誤"
                return
            }
            SQL.singleton?.createNewCategory(
                category: alert.textFields![0].text!,
                costSheet: Double(alert.textFields![1].text!)!,
                complete: nil
            )
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        return alert
    }
    
    // 快速顯示錯誤訊息的 alert
    static func errorAlert(with str:String) -> UIAlertController{
        let alert = UIAlertController(title: "錯誤", message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
}





