
//
//  ListViewController.swift
//  xlambton
//
//  Copyright © 2018 jagdeep. All rights reserved.
//

import UIKit
import SQLite3


class ListViewController: UIViewController {
    var db: OpaquePointer?
    var agent : Agent?

    @IBAction func actionView(_ sender: Any) {
        if let selected = agent{
            self.performSegue(withIdentifier: "map", sender: self)
        }
    }
    var list = [Agent]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("agents.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }else{        }
        
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Agents (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, country TEXT,mission TEXT,date TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self

        readValues()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "map") {
            let vc = segue.destination as! MapZoneViewController
            vc.agent = agent
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
            let country = String(cString: sqlite3_column_text(stmt, 2))
            let mission = String(cString: sqlite3_column_text(stmt, 3))
            let date = String(cString: sqlite3_column_text(stmt, 4))
            list.append(Agent(name: name, mission: mission, country: country, date: date))
            //adding values to list
            print(String(cString: sqlite3_column_text(stmt, 1)))
        }
        self.tableView.reloadData()
    }
    
}


extension ListViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let agent = list[indexPath.row]
        cell.textLabel?.text = agent.name!
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        agent = list[indexPath.row]
    }
}


