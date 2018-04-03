//
//  SQL.swift
//  CostSheet
//
//  Created by elijah on 2018/3/19.
//  Copyright © 2018年 elijah. All rights reserved.
//

import Foundation
import SQLite

struct SQL{
    var SQLDataBase:Connection?     // 資料庫接口
    
    init?(){
        if !connectSQLFile(){return nil}
    }
    
    // MARK: 主功能函數
    // 跟資料庫連線
    mutating func connectSQLFile() -> Bool{
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
    // 建立所有資料庫
    func establishAllTable(){
        try!establishCategoryTable()
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
    
    // MARK: 預算分類
    let Category = Table("Category")
    let category = Expression<String>("category")
    let costSheet = Expression<Double>("coseSheet")
    let index = Expression<Int>("index")
    let id = Expression<Int>("id")
    
    func establishCategoryTable() throws{
        if let _ = try? SQLDataBase?.run(Category.create(ifNotExists:true){t in
            t.column(id, primaryKey: true)
            t.columns([category, costSheet, index])
        }){}
        else{
            throw SQLErrors.extablishCategoryTableFail
        }
    }
    
    func createNewCategory(category:String, costSheet:Double, complete:(()->Void)?){
        var categoryCount = 0
        if let lastData = try? SQLDataBase!.prepare(Category.limit(1).order(id.desc)).first(where: { (row) -> Bool in
            return true
        }){
            if lastData != nil{
                categoryCount = lastData![id]
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
    
    func removeCategory(by id:Int){
        let delete = Category.filter(self.id == id).delete()
        let _ = try? SQLDataBase?.run(delete)
        notificationCategorySQLChanged()
    }
    
    // 把兩筆資料的顯示順序互換
    func changeCategoryIndex(with id_1:Int, and id_2:Int){      // 把兩個資料的 Index 對調
        // 確認有撈到東西
        let obj_1 = try? SQLDataBase?.prepare(Category.filter(id == id_1)).first(where: { (row) -> Bool in
            return true
        })
        let obj_2 = try? SQLDataBase?.prepare(Category.filter(id == id_2)).first(where: { (row) -> Bool in
            return true
        })
        guard obj_1 != nil && obj_2 != nil else {
            return
        }
        // 開始互換
        let tempIndex = obj_1!![index]
        let _ = try? SQLDataBase?.run(Category.filter(id == id_1).update(index <- obj_2!![index]))
        let _ = try? SQLDataBase?.run(Category.filter(id == id_2).update(index <- tempIndex))
        notificationCategorySQLChanged()
    }
    
    // 取得所有“分類”項目下的資料
    func getAllCategoryData() -> Array<SettingTableViewCategoryCellData>{
        var resultArray:Array<SettingTableViewCategoryCellData> = []
        if let dataRows = try! SQLDataBase?.prepare(Category.order(index.asc)){
            for row in dataRows{
                resultArray.append(SettingTableViewCategoryCellData(
                    databaseId: row[id],
                    category: row[category],
                    index: row[index],
                    costSheet: row[costSheet],
                    moneyUnit: moneyUnitSymbl!))
            }
        }
        return resultArray
    }
        // for test
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
            return testData?[id]
        }
        return nil
    }
    
    
    // MARK: 明細紀錄
    let CostDetail = Table("CostDetail")
    let categoryPk = Expression<Int>("categoryPk")
    let cost = Expression<Int>("cost")
    let time = Expression<Int>("time")
    let imgPath = Expression<String>("imgPath")
    
    func establishCostDetail() throws{
        if let _ = try? SQLDataBase?.run(CostDetail.create(ifNotExists:true){t in
            t.column(id, primaryKey: true)
            t.foreignKey(categoryPk, references: Category, id, update: .cascade, delete: .cascade)
            t.columns([cost, time, imgPath])
        }){}
        else{
            throw SQLErrors.establishCostDetailFail
        }
    }
    
    // MARK: private function
    private func notificationCategorySQLChanged(){
        NotificationCenter.default.post(Notification(name: Notification.Name(catagorySQLChanged)))
    }
    
}

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













