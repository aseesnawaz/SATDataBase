//
//  ViewController.swift
//  SATDataBase
//
//  Created by Asees on 2/28/15.
//  Copyright (c) 2015 Asees. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var status: UILabel!
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchpathDirectory.DocumentDirectory, NSSearchPathDomainMask.All, true)
        
        let docsDir = dirPaths[0] as String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "contacts.db")
        if !filemgr.fileExistsAtPath(databasePath) {
            
            let contactDB = FMDatabase(path: databasePath)
            
            if contactDB == nil {
                println("Error: \(contactDB.lastErrorMessage())")
            }
            
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, USERNAME TEXT, EMAIL TEXT)"
                if !contactDB.executeStatements(sql_stmt) {
                    println("Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                println("Error: \(contactDB.lastErrorMessage())")
            }
        }
    }

    @IBAction func saveData(sender: AnyObject) {
        let contactDB = FMDatabase(path: databasePath)
        
        if contactDB.open() {
            
            let insertSQL = "INSERT INTO CONTACTS (name, username, email) VALUES ('\(name.text)', '\(username.text)', '\(email.text)')"
            
            let result = contactDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                status.text = "Failed to add contact"
                println("Error: \(contactDB.lastErrorMessage())")
            } else {
                status.text = "Contact Added"
                name.text = ""
                username.text = ""
                email.text = ""
            }
        } else {
            println("Error: \(contactDB.lastErrorMessage())")
        }
    }
    @IBAction func findContact(sender: AnyObject) {
        let contactDB = FMDatabase(path: databasePath)
        
        if contactDB.open() {
            let querySQL = "SELECT username, email FROM CONTACTS WHERE name = '\(name.text)'"
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            if results?.next() == true {
                username.text = results?.stringForColumn("username")
                email.text = results?.stringForColumn("email")
                status.text = "Record Found"
            } else {
                status.text = "Record not found"
                username.text = ""
                email.text = ""
            }
            contactDB.close()
        } else {
            println("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

