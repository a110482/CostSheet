//
//  SettingTableCell.swift
//  CostSheet
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import UIKit

class BasicSettingCell:UITableViewCell{
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var costSheet: UILabel!
}

class SettingTableViewCategoryCell:BasicSettingCell{

}

class SettingTableViewFixedCostCell:BasicSettingCell{
    @IBOutlet weak var terms: UILabel!
}










