//
//  SQL.swift
//  CostSheet
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import SQLite

/// 這是SQL的singletom 初始化以後會連線到資料庫檔案
struct SQL{
    static let singleton = SQL()
    private var SQLDataBase:Connection?     // 資料庫接口
    
    init?(){
        if !connectSQLFile(){return nil}
    }
    
    // MARK: - 主功能函數
    // 跟資料庫連線
    private mutating func connectSQLFile() -> Bool{
        let urls = FileManager.default
            .urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString
            + "sqlite3.db"
        do{
            self.SQLDataBase = try Connection(sqlitePath)
            print("資料庫連線成功")
            return true
        }
        catch{
            print("資料庫錯誤")
            print(error)
            return false
        }
    }
    // MARK: interface
    // 建立所有資料庫
    func establishAllTable(){
        try!establishCategoryTable()
        do
        {
            try establishCostDetail()
            
        }
        catch{print(error)}
    }
    func dropAllTable(){
        let _  = try? SQLDataBase?.run(Category.drop())
        let _  = try? SQLDataBase?.run(CostDetail.drop())
    }
    
    // Errors
    enum SQLErrors:Error {
        case extablishCategoryTableFail
        case establishCostDetailFail
    }
    
    // MARK: - 預算分類
    // MARK: private
    private let Category = Table("Category")
    private let category = Expression<String>("category")
    private let costSheet = Expression<Double>("coseSheet")
    private let index = Expression<Int>("index")
    private let categoryId = Expression<Int>("categoryId")
    
    private func establishCategoryTable() throws{
        if let _ = try? SQLDataBase?.run(Category.create(ifNotExists:true){t in
            t.column(categoryId, primaryKey: true)
            t.columns([category, costSheet, index])
        }){}
        else{
            throw SQLErrors.extablishCategoryTableFail
        }
    }
    
    private func notificationCategorySQLChanged(){
        NotificationCenter.default.post(Notification(name: Notification.Name(catagorySQLChanged)))
    }
    
    // MARK: interface
    func createNewCategory(category:String, costSheet:Double, complete:(()->Void)?){
        var categoryCount = 0
        if let lastData = try? SQLDataBase!.prepare(Category.limit(1).order(categoryId.desc)).first(where: { (row) -> Bool in
            return true
        }){
            if lastData != nil{
                categoryCount = lastData![categoryId]
            }
        }
        let insert = Category.insert(
            self.category <- category,
            self.costSheet <- costSheet,
            self.index <- categoryCount
        )
        let _ = try? SQLDataBase?.run(insert)
        complete?()
        notificationCategorySQLChanged()
    }
    
    func removeCategory(byID id:Int){
        let delete = Category.filter(self.categoryId == id).delete()
        let _ = try? SQLDataBase?.run(delete)
        notificationCategorySQLChanged()
    }
    
    // 把兩筆資料的顯示順序互換
    func changeCategoryIndex(withID id_1:Int, andID id_2:Int){      // 把兩個資料的 Index 對調
        // 確認有撈到東西
        let obj_1 = try? SQLDataBase?.prepare(Category.filter(categoryId == id_1)).first(where: { (row) -> Bool in
            return true
        })
        let obj_2 = try? SQLDataBase?.prepare(Category.filter(categoryId == id_2)).first(where: { (row) -> Bool in
            return true
        })
        guard obj_1 != nil && obj_2 != nil else {
            return
        }
        // 開始互換
        let tempIndex = obj_1!![index]
        let _ = try? SQLDataBase?.run(Category.filter(categoryId == id_1).update(index <- obj_2!![index]))
        let _ = try? SQLDataBase?.run(Category.filter(categoryId == id_2).update(index <- tempIndex))
        notificationCategorySQLChanged()
    }
    
    // 取得所有“分類”項目下的資料
    func getAllCategoryData() -> Array<SettingTableViewCategoryCellData>{
        var resultArray:Array<SettingTableViewCategoryCellData> = []
        if let dataRows = try! SQLDataBase?.prepare(Category.order(index.asc)){
            for row in dataRows{
                resultArray.append(SettingTableViewCategoryCellData(
                    databaseId: row[categoryId],
                    category: row[category],
                    index: row[index],
                    costSheet: row[costSheet],
                    moneyUnit: moneyUnitSymbl!))
            }
        }
        return resultArray
    }
    // MARK: for XCTest
    func seeCategoryDatabase(){
        if let data = try! SQLDataBase?.prepare(Category){
            print("--start print database--")
            for c in data{
                print("\(c[category])  costSheet: \(c[costSheet])  index: \(c[index])")
            }
        }
    }
    func getTestDataRow() -> Int?{
        if let testData = try? SQLDataBase?.prepare(Category).first(where: { (_) -> Bool in
            return true
        }){
            return testData?[categoryId]
        }
        return nil
    }
    
    
    // MARK: - 明細紀錄
    // MARK: private
    private let CostDetail = Table("CostDetail")
    private let costDetailId = Expression<Int>("costDetailId")
    private let categoryPk = Expression<Int>("categoryPk")
    private let cost = Expression<Int>("cost")
    private let time = Expression<Int>("time")
    private let imgPath = Expression<String>("imgPath")
    
    private func establishCostDetail() throws{
        if let _ = try? SQLDataBase?.run(CostDetail.create(ifNotExists:true){t in
            t.column(costDetailId, primaryKey: true)
            t.columns([categoryPk, cost, time, imgPath])
            t.foreignKey(categoryPk, references: Category, categoryId, update: nil, delete: .setNull)
        }){}
        else{
            throw SQLErrors.establishCostDetailFail
        }
    }
    
    // MARK: - 固定金額開銷
    // MARK: private
    private let FixedCost = Table("FixedCost")
    private let FixedCostId = Expression<Int>("FixedCostId")
    private let fixedCostDetail = Expression<String>("fixedCostDetail")
    private let expirationDate = Expression<Int?>("ExpirationDate")   // 記錄最後一筆付款時間的秒數since 1970
    // FIXME: cell新增此項目
    private let terms = Expression<String>("terms")
    private let payData = Expression<Int>("payData")  // 付款日 每月的幾號
    // FIXME: cell新增此項目
    private let isPaid = Expression<Bool>("isPaid")
    private let showDetailMode = Expression<Int>("showDetailMode")
    // FIXME: 最後一欄有四種顯示模式
    // 剩餘幾期要繳
    // 剩餘總金額
    // 最後一天付款日
    // 距離最後一天付款日還有多久
    // 本資料庫可能要新增欄位來記錄顯示模式
    // 最後一欄 用滾動式選單來決定顯示項目  克制畫滾動清單讓他可以套到所有cell  一個小勾勾之累的
    private func establishFixedCost() throws{
        if let _ = try? SQLDataBase?.run(FixedCost.create(ifNotExists:true){t in
            t.column(FixedCostId, primaryKey: true)
            t.columns([fixedCostDetail, expirationDate, terms, payData, isPaid, showDetailMode])
        }){}
        else{
            throw SQLErrors.establishCostDetailFail
        }
    }
    
    
    // MARK: - 使用者設定
    private let UserConfig = Table("UserConfig")
    private let resetDate = Expression<Int>("resetDate")
    
    private func establishUserConfig(){
        // FIXME: 實作
    }
    
}

// 擴充寫入 column 的語法
extension TableBuilder{
    func columns(_ list:Array<Any>){
        for c in list{
            if let val = c as? Expression<String>{
                self.column(val)
            }
            else if let val = c as? Expression<Int>{
                self.column(val)
            }
            else if let val = c as? Expression<Double>{
                 self.column(val)
            }
        }
    }
}













