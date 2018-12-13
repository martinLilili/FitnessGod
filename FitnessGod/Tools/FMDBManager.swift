//
//  FMDBManager.swift
//  FitnessGod
//
//  Created by cruzr on 2018/12/6.
//  Copyright © 2018 martin. All rights reserved.
//

import UIKit

class FMDBManager: NSObject {
    
    static let share = FMDBManager()
    
    let databaseFileName = "FGDatabase.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    var queue : FMDatabaseQueue!
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        
        _ = createDatabase()
        queue = FMDatabaseQueue(path: pathToDatabase)
    }
    
    func createDatabase() -> Bool {
        var created = false
        
        database = FMDatabase(path: pathToDatabase!)
        
        if database != nil {
            // Open the database.
            if database.open() {
                let createRobotsTableQuery = "create table IF NOT EXISTS plans (\(PlanKey.planID) integer primary key autoincrement not null, \(PlanKey.datetime) text, \(PlanKey.data) blob not null)"
                do {
                    try database.executeUpdate(createRobotsTableQuery, values: nil)
                    created = true
                }
                catch {
                    print("Could not create table.")
                    print(error.localizedDescription)
                }
                
                database.close()
            }
            else {
                print("Could not open the database.")
            }
        }
        database = nil
        
        return created
    }
    
    func dateToTime(date : Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let time =  dateFormatter.string(from: date ?? Date())
        return time
    }
    
    func loadLastPlan(count : Int = 1, completionHandler: @escaping (_ plans: [Plan5x5]) -> Void)  {
        var plans: [Plan5x5] = [Plan5x5]()
        queue.inDatabase({ (db) in
            if db != nil {
                let query = "SELECT * FROM plans AS TD ORDER BY TD.planID DESC LIMIT 0,\(count)"
                do {
                    let results = try db!.executeQuery(query, values: nil)
                    while results.next() {
                        do {
                            let plan = try JSONDecoder().decode(Plan5x5.self,from:results.data(forColumn: PlanKey.data))
                            plans.append(plan)
                        } catch  {
                            print("Error enableBroadcast (bind):\(error)")
                            completionHandler(plans)
                        }
                    }
                    DispatchQueue.main.async {
                        completionHandler(plans)
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            } else {
                
            }
        })
    }
    
    func loadAllPlans(completionHandler: @escaping (_ plans: [Plan5x5]) -> Void)  {
        var plans: [Plan5x5] = [Plan5x5]()
        queue.inDatabase({ (db) in
            if db != nil {
                let query = "select * from plans"
                do {
                    let results = try db!.executeQuery(query, values: nil)
                    while results.next() {
                        do {
                            let plan = try JSONDecoder().decode(Plan5x5.self,from:results.data(forColumn: PlanKey.data))
                            print("plan id = \(results.int(forColumn: PlanKey.planID))")
                            plans.append(plan)
                        } catch  {
                            print("Error enableBroadcast (bind):\(error)")
                            completionHandler(plans)
                        }
                    }
                    DispatchQueue.main.async {
                        completionHandler(plans)
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            } else {
                
            }
        })
    }
    
    func loadPlans(withPlan tplan : Plan5x5, completionHandler: @escaping (_ plans: [Plan5x5], _ db : FMDatabase) -> Void)  {
        var plans: [Plan5x5] = [Plan5x5]()
        queue.inDatabase({ (db) in
            if db != nil {
                let time =  self.dateToTime(date: tplan.date)
                let query = "select * from plans where \(PlanKey.datetime)=?"
                do {
                    let results = try db!.executeQuery(query, values: [time])
                    while results.next() {
                        do {
                            let plan = try JSONDecoder().decode(Plan5x5.self,from:results.data(forColumn: PlanKey.data))
                            plans.append(plan)
                        } catch  {
                            print("Error enableBroadcast (bind):\(error)")
                            DispatchQueue.main.async {
                                completionHandler(plans, db!)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        completionHandler(plans, db!)
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            } else {
                
            }
        })
    }
    
    func insertPlan(aplan : Plan5x5, completionHandler: (() -> Void)? = nil) {
        loadPlans(withPlan: aplan) { (plans, db) in
            if plans.isEmpty {
                do {
                    let encodedData = try JSONEncoder().encode(aplan)
                    let time = self.dateToTime(date: aplan.date)
                    let query = "insert into plans (\(PlanKey.datetime), \(PlanKey.data)) values (?, ?);"
                    try db.executeUpdate(query, values: [time, encodedData])
                    DispatchQueue.main.async {
                        completionHandler?()
                    }
                } catch  {
                    print("Error enableBroadcast (bind):\(error)")
                }
            } else {
//                let time = self.dateToTime(date: aplan.date)
//                self.updatePlan(aplan: aplan, oldTime: time)
            }
        }
    }
    
    func updatePlan(aplan : Plan5x5, oldTime : String) {
        queue.inDatabase { (db) in
            if db != nil {
                let time = self.dateToTime(date: aplan.date)
                do {
                    let encodedData = try JSONEncoder().encode(aplan)
                    let query = "update plans set \(PlanKey.datetime)=?, \(PlanKey.data)=?  where \(PlanKey.datetime)=?"
                    try db!.executeUpdate(query, values: [time, encodedData, oldTime])
                }
                catch {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func deleteRobot(aplan : Plan5x5, completionHandler: (() -> Void)? = nil) {
        queue.inDatabase { (db) in
            if db != nil {
                let query = "delete from plans where \(PlanKey.datetime)=?"
                do {
                    let time = self.dateToTime(date: aplan.date)
                    try db!.executeUpdate(query, values: [time])
                    DispatchQueue.main.async {
                        completionHandler?()
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

}
