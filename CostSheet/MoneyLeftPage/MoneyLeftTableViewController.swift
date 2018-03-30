//
//  MoneyLeftTableViewController.swift
//  CostSheet
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import UIKit

class MoneyLeftTableViewController:UITableViewController{
    var model = MoneyLeftTableViewModel()
    var selectCellIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: Notification.Name(moneyLeftTableViewModelUpdate), object: nil, queue: OperationQueue.main) { (nos) in
            self.reload()
        }
    }
    @objc func reload(){
        self.tableView?.reloadData()
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.tableViewData.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moneyLeftCell") as! MoneyLeftCell
        let data = model.tableViewData[indexPath.row]
        
        cell.category.text = data.category
        
        // 若小數點後無數字，不顯示小數點
        let moneyLeftInt = Int(data.moneyLeft)
        let moneyShowOnCell:String
        if data.moneyLeft - Double(moneyLeftInt) == 0{
            moneyShowOnCell = "\(moneyLeftInt)"
        }
        else{
            moneyShowOnCell = "\(data.moneyLeft)"
        }
        
        cell.moneyLeft.text = "\(data.moneyUnit) \(moneyShowOnCell)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectCellIndex = indexPath.row
        performSegue(withIdentifier: "moneryDetailSegue", sender: self)
    }
}












