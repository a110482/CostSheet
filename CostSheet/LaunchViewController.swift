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
    var tabBarViewController:mainTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SQL.singleton?.establishAllTable()
        segueToMainView()
    }
    
    private func segueToMainView(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueToMainView", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMainView"{
            tabBarViewController = segue.destination as? mainTabBarController
        }
    }
}
