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
            let cellRect = childVC.tableView.rectForRow(at: newIndex)
            let cellTotleMinHeight = cellRect.origin.y
            let scroolPosition = UITableViewScrollPosition.none     // 變換位置後 scroll的位置
            childVC.tableView.selectRow(at: newIndex, animated: true, scrollPosition: scroolPosition)
            if !childVC.tableView.bounds.contains(CGPoint(x: 0, y: cellTotleMinHeight)){    // 如果新位置 不再可視範圍內
                //scroolPosition = .top
                childVC.tableView.scrollToRow(at: newIndex, at: .top, animated: true)
            }
            
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
            //if childVC.tableView.cellForRow(at: newIndex).vis
            let cellRect = childVC.tableView.rectForRow(at: newIndex)
            let cellTotleMaxHeight = cellRect.origin.y + cellRect.height
            var scroolPosition = UITableViewScrollPosition.none
            if childVC.tableView.bounds.contains(CGPoint(x: 0, y: cellTotleMaxHeight)){
                scroolPosition = .bottom
            }
            childVC.tableView.selectRow(at: newIndex, animated: true, scrollPosition: scroolPosition)
            
        }
    }
    
    // MARK: static function
    static func insertNewItemToSQL(){
        
    }
    
     
}








