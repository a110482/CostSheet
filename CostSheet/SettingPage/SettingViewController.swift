//
//  SettingViewController.swift
//  CostSheet
//
//  Created by elijah on 2018/3/20.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import UIKit


class SettingViewController:UIViewController{
    
    private var tablePresentMode = TableViewPresentMode.categort
    private var settingTableViewController:SettingTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableViewController = self.childViewControllers[0] as! SettingTableViewController
    }
    
    @IBAction func setCategory(_ sender: Any) {
        settingTableViewController.setTablePresentMode(mode: .categort)
    }
    
    @IBAction func setFixedCost(_ sender: Any) {
        settingTableViewController.setTablePresentMode(mode: .fixedCost)
    }
    
    @IBAction func removeItem(_ sender: Any) {
        let childVC = self.childViewControllers[0] as! SettingTableViewController
        if let selectIndex = childVC.getSelectCellIndex(){
            guard selectIndex.row <= childVC.settingTableDataListCount() else{return}
            let selectCell = childVC.getCell(Index: selectIndex)
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
        if let selectIndex = childVC.getSelectCellIndex(){
            guard selectIndex.row <= childVC.settingTableDataListCount() - 1 else{return}
            guard selectIndex.row - 1 >= 0 else{return}
            let selectCell = childVC.getCell(Index: selectIndex)
            let selectAboveCell = childVC.getCell(Index: IndexPath(row: selectIndex.row - 1, section: 0))
            if tablePresentMode == .categort{
                SQL.singletom?.changeCategoryIndex(withID: selectCell.databaseId, andID: selectAboveCell.databaseId)
            }
            else{
                
            }
            let newIndex = IndexPath(row: selectIndex.row - 1, section: 0)
            childVC.setSelectCellIndex(newIndex: newIndex)
        }
    }
    
    @IBAction func downItem(_ sender: Any) {
        let childVC = self.childViewControllers[0] as! SettingTableViewController
        if let selectIndex = childVC.getSelectCellIndex(){
            guard selectIndex.row + 1 <= childVC.settingTableDataListCount() - 1 else{return}
            let selectCell = childVC.getCell(Index: selectIndex)
            let selectBelowCell = childVC.getCell(Index: IndexPath(row: selectIndex.row + 1, section: 0))
            if tablePresentMode == .categort{
                SQL.singletom?.changeCategoryIndex(withID: selectCell.databaseId, andID: selectBelowCell.databaseId)
            }
            else{
                
            }
            let newIndex = IndexPath(row: selectIndex.row + 1, section: 0)
            childVC.setSelectCellIndex(newIndex: newIndex)
        }
    }
    
}

enum TableViewPresentMode{
    case categort
    case fixedCost
}







