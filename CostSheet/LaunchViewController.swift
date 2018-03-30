//
//  LaunchViewController.swift
//  CostSheet
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import UIKit

class LaunchViewController:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let sql = SQLCenter()
        sql?.establishAllTable()
        segueToMainView()
    }
    
    private func segueToMainView(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueToMainView", sender: nil)
        }
    }
}
