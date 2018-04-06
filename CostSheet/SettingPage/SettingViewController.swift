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
            self.present(CustomAlertStingleton.addNewCategory(), animated: true, completion: nil)
        }
    }
    @IBAction func upItem(_ sender: Any) {
    }
    @IBAction func downItem(_ sender: Any) {
    }
    
    // MARK: static function
    static func insertNewItemToSQL(){
        
    }
    
     
}








