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
        let childVC = self.childViewControllers[0] as! SettingTableViewController
        if let selectIndex = childVC.selectCellIndex{
            guard selectIndex.row <= childVC.settingTableDataList.count else{return}
            let selectCell = childVC.settingTableDataList[selectIndex.row]
            if tablePresentMode == .categort{
                SQL.singletom?.removeCategory(byID: selectCell.databaseId)
            }
            else{
                
            }
        }
    }
    @IBAction func addItem(_ sender: Any) {
        if tablePresentMode == .categort{
            self.present(CustomAlertStingleton.addNewCategory(), animated: true, completion: nil)
        }
    }
    @IBAction func upItem(_ sender: Any) {
        let childVC = self.childViewControllers[0] as! SettingTableViewController
        if let selectIndex = childVC.selectCellIndex{
            guard selectIndex.row <= childVC.settingTableDataList.count - 1 else{return}
            guard selectIndex.row - 1 >= 0 else{return}
            let selectCell = childVC.settingTableDataList[selectIndex.row]
            let selectAboveCell = childVC.settingTableDataList[selectIndex.row - 1]
            if tablePresentMode == .categort{
                SQL.singletom?.changeCategoryIndex(withID: selectCell.databaseId, andID: selectAboveCell.databaseId)
            }
            else{
                
            }
            let newIndex = IndexPath(row: selectIndex.row - 1, section: 0)
            childVC.selectCellIndex = newIndex
        }
    }
    @IBAction func downItem(_ sender: Any) {
        let childVC = self.childViewControllers[0] as! SettingTableViewController
        if let selectIndex = childVC.selectCellIndex{
            guard selectIndex.row + 1 <= childVC.settingTableDataList.count - 1 else{return}
            let selectCell = childVC.settingTableDataList[selectIndex.row]
            let selectBelowCell = childVC.settingTableDataList[selectIndex.row + 1]
            if tablePresentMode == .categort{
                SQL.singletom?.changeCategoryIndex(withID: selectCell.databaseId, andID: selectBelowCell.databaseId)
            }
            else{
                
            }
            let newIndex = IndexPath(row: selectIndex.row + 1, section: 0)
            childVC.selectCellIndex = newIndex
        }
    }
    
    // MARK: static function
    static func insertNewItemToSQL(){
        
    }
    
     
}








