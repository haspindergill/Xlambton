//
//  AddAgentViewController.swift
//  xlambton
//
//  Copyright © 2018 jagdeep. All rights reserved.
//

import UIKit
import SQLite3

class AddAgentViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
   
    var db: OpaquePointer?


    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tMission: UITextField!
    @IBOutlet weak var tCountry: UITextField!
    @IBOutlet weak var tDate: UITextField!
    
    var selectedField = 1
    var pickerView = UIPickerView()
    let datePicker = UIDatePicker()

    let missions = ["I","R","P"]
    let countries = ["Canada","USA","UK","INDIA"]

    
    @IBAction func save(_ sender: Any) {
        var stmt: OpaquePointer?
        
        //the insert query
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("agents.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }else{
            print("perfect")
        }
        
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Agents (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, country TEXT,mission TEXT,date TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        let queryString = "INSERT INTO Agents (name, country,mission,date) VALUES ('\(String(describing: UtilityFunctions.createCodeforAlphabet(text: tName.text ?? "")))','\(String(describing: tCountry.text ?? ""))','\(String(describing: tMission.text ?? ""))','\(String(describing: tDate.text ?? ""))')"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        self.dismiss(animated: true) {}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        tMission.inputView = pickerView
        tCountry.inputView = pickerView
        tDate.inputView = datePicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        tCountry.inputAccessoryView = toolBar
        tMission.inputAccessoryView = toolBar
        tDate.inputAccessoryView = toolBar


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day)\(month)\(year)")
            tDate.text = "\(day)\(month)\(year)"
        }
    }
    
    
    @objc func done() {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectedField {
        case 1:
            return missions.count
        case 2:
            return countries.count
        default:
            return missions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedField {
        case 1:
            return missions[row]
        case 2:
            return countries[row]
        default:
            return missions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let txtField1 = self.view.viewWithTag(selectedField) as? UITextField {
            switch selectedField {
            case 1:
                txtField1.text = missions[row]
            case 2:
                txtField1.text = countries[row]
            default:
                txtField1.text = missions[row]
            }
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedField = textField.tag
        pickerView.reloadAllComponents()
        pickerView.reloadInputViews()
    }
    

}
