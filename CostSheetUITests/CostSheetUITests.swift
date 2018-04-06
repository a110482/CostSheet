//
//  CostSheetUITests.swift
//  CostSheetUITests
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//

import XCTest
@testable import CostSheet

class CostSheetUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
//        SQL.singletom?.dropAllTable()
//        SQL.singletom?.establishAllTable()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSettingView() {
        // 切換到tabView
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["設定"].tap()
        
        let tablesQuery = app.tables
        
        let staticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["✚"]/*[[".cells.staticTexts[\"✚\"]",".staticTexts[\"✚\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        
        let alert = app.alerts["建立新類別"]
        let collectionViewsQuery = alert.collectionViews
        collectionViewsQuery.textFields["新分類"].typeText("01")
        
        let textField = collectionViewsQuery.textFields["預算額度"]
        textField.tap()
        textField.typeText("1000")
        alert.buttons["確認"].tap()
        tablesQuery.children(matching: .cell).element(boundBy: 7).staticTexts["預算"].swipeUp()
        staticText.tap()
        collectionViewsQuery.textFields["新分類"].typeText("02")
        textField.tap()
        textField.typeText("2000")
        alert.buttons["確認"].tap()
        
        
        
        
        
        
        print("sss")
    }
    
}
