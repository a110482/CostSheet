//
//  SettingTableViewController.swift
//  CostSheet
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import UIKit

// tabview 可能顯示兩種資料內容(categort or fixedCost) 但同時只會顯示一種
// cell 更新機制： 1. (資料庫變動 發送NotificationCenter 給model) 或是 (手動切換更新模式 由本ＶＣ要求model去SQL撈資料)
//               2. model 發送 NotificationCenter 通知 VC 資料有更新
//               3. 本ＶＣ 拷貝一份 資料的array到本地 然後加上一個“新增”的cell 再刷新頁面
class SettingTableViewController:UITableViewController{
    // MARK: - interface
    // 取得現在選擇的cell index
    func getSelectCellIndex() -> IndexPath?{
        return selectCellIndex
    }
    // 重設現在選擇的cell index
    func setSelectCellIndex(newIndex:IndexPath){
        selectCellIndex = newIndex
    }
    // 變更tableview 顯示內容
    func setTablePresentMode(mode:TableViewPresentMode){
        tablePresentMode = mode
    }
    // 取得某個cell的資料內容
    func getCell(Index:IndexPath) -> BasicCellData{
        return settingTableDataList[Index.row]
    }
    // 取得現在資料長度
    func settingTableDataListCount() -> Int{
        return settingTableDataList.count
    }
    
    // MARK: - variable
    private var tablePresentMode = TableViewPresentMode.categort{   // 記錄現在tableView的顯示內容是哪一種
        didSet{
            if tablePresentMode == .categort{
                NotificationCenter.default.post(Notification(name: Notification.Name(catagorySQLChanged)))
            }
            else if tablePresentMode == .fixedCost{
                NotificationCenter.default.post(Notification(name: Notification.Name(fixedCostSQLChanged)))
            }
        }
    }
    private let model = SettingTableViewModel()
    private var selectCellIndex:IndexPath?{
        didSet{
            tableView.selectRow(at: selectCellIndex!, animated: false, scrollPosition: .none)
            adjustmentScrollPosition(cellIndex: selectCellIndex!)
        }
    }
    private var settingTableDataList:Array<BasicCellData> = []
    
    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 註冊具有“新增項目”功能的 cell
        let nib = UINib(nibName: "PlusActionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PlusActionCell")
        
        NotificationCenter.default.addObserver(forName: Notification.Name(settingTableCatagoryDataListUpdata), object: nil, queue: OperationQueue.main) {[weak self] (_) in
            guard self != nil && self!.tablePresentMode == .categort else{return}
            self?.settingTableDataList = (self?.model.getSettingCatagoryTableDataList())!
            self?.customReloadTableView()
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(settingTableFixedCostDataListUpdata), object: nil, queue: OperationQueue.main) {[weak self] (_) in
            guard self != nil && self!.tablePresentMode == .fixedCost else{return}
            self?.settingTableDataList = (self?.model.getSettingFixedCostTableDataList())!
            self?.customReloadTableView()
        }
        tablePresentMode = .categort
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTableDataList.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // “新增項目”功能的 cell
        guard indexPath.row < self.settingTableDataList.count else {
            let plusCell = tableView.dequeueReusableCell(withIdentifier: "PlusActionCell") as! PlusActionCell
            
            // 增加點擊手勢
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAddCell))
            plusCell.addGestureRecognizer(tapGesture)
            
            return plusCell
        }
        
        // 顯示一般 cell
        var basicCellData = settingTableDataList[indexPath.row]
        let basicCell:BasicSettingCell
        
        // 根據狀況給予不同的cell
        switch tablePresentMode {
        case .categort:
            basicCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCategoryCell") as! SettingTableViewCategoryCell
        case .fixedCost:
            basicCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewFixedCostCell") as! SettingTableViewFixedCostCell
        }
        
        // 先塞入共用資料
        basicCell.category.text = basicCellData.category
        basicCell.costSheet.text = basicCellData.costSheet.tryToCutDotString()
        
        // 再塞每種cell不同的資料
        if let categoryCell = basicCell as? SettingTableViewCategoryCell{
            return categoryCell
        }
        else if let fixedCostCell = basicCell as? SettingTableViewFixedCostCell{
            let fixedCostcellData = basicCellData as! SettingTableViewFixedCostCellData
            fixedCostCell.terms.text = fixedCostcellData.terms
            return fixedCostCell
        }
        else{
            return basicCell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCellIndex = indexPath
    }
    
    // MARK: - private function
    // 客製化的reload table view
    private func customReloadTableView(){
        self.tableView.reloadData()
        scrollFirestCellToTop()
    }
    
    // 點擊加號按鈕
    @objc private func tapAddCell(){
        if tablePresentMode == .categort{
            self.present(CustomAlertStingleton.addNewCategory(), animated: true, completion: nil)
        }
    }
    
    // 調整cell選擇後顯示視角
    private func adjustmentScrollPosition(cellIndex:IndexPath){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
            guard self != nil else {return}
            let cellRect = self!.tableView.rectForRow(at: cellIndex)
            let cellOriginHeight = cellRect.origin.y
            let cellDistanceWithTableViewTop = abs(self!.tableView.bounds.origin.y - cellOriginHeight)
            let cellDistanceWithTableViewBottom = abs(self!.tableView.bounds.origin.y + self!.tableView.bounds.size.height - cellOriginHeight)
            
            if cellDistanceWithTableViewTop < cellDistanceWithTableViewBottom{  // cell 現在比較靠近頂端
                if !self!.tableView.bounds.contains(CGPoint(x: 0, y: cellOriginHeight)){
                    self!.tableView.scrollToRow(at: cellIndex, at: .top, animated: true)
                }
            }
            else{   // cell 現在比較靠近底部
                if !self!.tableView.bounds.contains(CGPoint(x: 0, y: (cellOriginHeight + cellRect.size.height))){
                    self!.tableView.scrollToRow(at: cellIndex, at: .bottom, animated: true)
                }
            }
        }
        
    }
    
    // 切換頁面後 把scroll 推到最上面
    private func scrollFirestCellToTop(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            guard self != nil else{return}
            self!.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
}







