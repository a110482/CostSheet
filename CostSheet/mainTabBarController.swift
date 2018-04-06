//
//  mainTabBarController.swift
//  CostSheet
//
//  Created by elijah on 2018/4/6.
//  Copyright © 2018年 elijah. All rights reserved.
//

import UIKit

class mainTabBarController: UITabBarController {
    // 錯誤訊息送到此處時 會自動跳出alert
    var errorAlertString = String(){
        didSet{
            self.present(CustomAlertStingleton.errorAlert(with: errorAlertString), animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
