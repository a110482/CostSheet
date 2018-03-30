//
//  CostSheetTests.swift
//  CostSheetTests
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//

import XCTest
@testable import CostSheet
import SQLite

class CostSheetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: SettingViewController
    func testcheckIntVaild(){
        let vc = SettingViewController()
        var result = vc.checkDoubleVaild(text: nil)
        XCTAssert(!result)
        result = vc.checkDoubleVaild(text: "037")
        XCTAssert(result)
        result = vc.checkDoubleVaild(text: " 37")
        XCTAssert(result)
        result = vc.checkDoubleVaild(text: "3.7")
        XCTAssert(result)
    }
    func testcheckTextVaild(){
        let vc = SettingViewController()
        let result = vc.checkTextVaild(text: nil)
        XCTAssert(!result)
    }
    
    // MARK: SQLCenter
    func testdropAllTable(){
        let sql = SQL()
        sql?.dropAllTable()
    }
    
    func testextablishAllTable(){
        let sql = SQL()
        sql?.establishAllTable()
    }
    func testinsertDemoData(){
        let sql = SQL()
        
        sql?.seeCategoryDatabase()
        
        let countBefore = try! sql!.SQLDataBase!.scalar((sql?.Category.count)!)
        // 測試寫入
        sql?.createNewCategory(category: "衣服", costSheet: 5000)
        sql?.createNewCategory(category: "鞋子", costSheet: 2000)
        let countAfter = try! sql!.SQLDataBase!.scalar((sql?.Category.count)!)
        XCTAssert(countAfter - countBefore == 2)
        
        //sql?.seeCategoryDatabase()
        
        // 測試變更index(顯示順序)
        let testDataId = sql!.getTestDataRow()!
        let index_1 = try! sql!.SQLDataBase!.prepare(sql!.Category.filter(sql!.id == testDataId)).first { (row) -> Bool in
            return true
            }![sql!.index]
        let index_2 = try! sql!.SQLDataBase!.prepare(sql!.Category.filter(sql!.id == testDataId + 1)).first { (row) -> Bool in
            return true
            }![sql!.index]
        sql!.changeCategoryIndex(with:testDataId, and:testDataId + 1)
        let newIndex_1 = try! sql!.SQLDataBase!.prepare(sql!.Category.filter(sql!.id == testDataId)).first { (row) -> Bool in
            return true
            }![sql!.index]
        let newIndex_2 = try! sql!.SQLDataBase!.prepare(sql!.Category.filter(sql!.id == testDataId + 1)).first { (row) -> Bool in
            return true
            }![sql!.index]
        //sql?.seeCategoryDatabase()
        XCTAssert(index_1 == newIndex_2 && index_2 == newIndex_1)
        // 測試刪除
        sql!.removeCategory(by:testDataId)
        sql!.removeCategory(by:testDataId + 1)
        let countEnd = try! sql!.SQLDataBase!.scalar((sql?.Category.count)!)
        //sql?.seeCategoryDatabase()
        XCTAssert(countEnd == countBefore)
    }
    
}













