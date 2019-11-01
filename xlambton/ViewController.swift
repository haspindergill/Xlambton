//
//  ViewController.swift
//  xlambton
//
//  Copyright © 2018 jagdeep. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

        var db: OpaquePointer?
    
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       

//
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            .appendingPathComponent("agents.sqlite")
//        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
//            print("error opening database")
//        }else{        }
//
//
//        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Agents (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, country TEXT,mission TEXT,date TEXT)", nil, nil, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error creating table: \(errmsg)")
//        }
//        readValues()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func readValues(){
        
        let queryString = "SELECT * FROM Agents"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let powerrank = String(cString: sqlite3_column_text(stmt, 2))
            print(name,powerrank)
            //adding values to list
        }
        
    }
  


    
    

}

