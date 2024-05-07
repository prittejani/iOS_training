//
//  SqlHelper.swift
//  sql
//
//  Created by iMac on 28/02/24.
//

import Foundation
import SQLite3

class SqlHelper{
    
    init(){
        db = openDatabse()
        createTable()
    }
    let dbPath:String = "db.sqlite"
    var db:OpaquePointer?
    
  
    func openDatabse() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)

        print(fileURL)
        var db:OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error to open database")
            return nil
        }else{
            print("database connected at \(dbPath)")

            return db
        }
    }

    func createTable (){
        let createTable = "CREATE TABLE IF NOT EXISTS tbluser(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,mobileno TEXT,email TEXT);"
        var createTableStatement:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTable, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("user table created")
            }else{
                print("user table not created")
            }
        }else{
            print("create table could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    func insert(name:String,mobileno:String,email:String){
        let insertString = "INSERT INTO tbluser(name,mobileno,email) VALUES (?,?,?);"
        var insertStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertString, -1, &insertStatement, nil) == SQLITE_OK{
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (mobileno as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (email as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Data inserted Successfully")
            }else{
                print("Data not inserted")
            }
        }else{
            print("insertStatement could not be prepared")
        }
        sqlite3_finalize(insertStatement)
    }
 
    
    func read () -> [UserModel] {
       let queryString = "SELECT * FROM tbluser;"
        var queryStatement:OpaquePointer? = nil
        var users:[UserModel] = []
        if sqlite3_prepare(db, queryString, -1, &queryStatement, nil) == SQLITE_OK{
            while sqlite3_step(queryStatement) == SQLITE_ROW{
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let mobileNo = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
              
                users.append(UserModel(id: Int(id), name: name, mobileno: mobileNo, email: email))
                print("\(id) : \(name) : \(mobileNo) : \(email)")
            }
        }else{
            print("select statement could not be prepared ")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
 
    
    func delete(id:Int){
        let deleteString = "DELETE FROM tbluser WHERE id = ?;"
        var deleteStatment:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatment, nil) == SQLITE_OK{
            sqlite3_bind_int(deleteStatment, 1, Int32(id))
            if sqlite3_step(deleteStatment) == SQLITE_DONE{
                print("Data deleted Successfully ")
            }else{
                print("Could not deleted row")
            }
        }else{
            print("select statement could not be prepared")
        }
            sqlite3_finalize(deleteStatment)
    }
    func update(id:Int,name:String,mobileno:String,email:String){
        let updateString = "UPDATE tbluser SET name = ?,mobileno = ?,email = ? WHERE id = ?;"
        var updateStatment:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateString, -1, &updateStatment, nil) == SQLITE_OK {
            
            sqlite3_bind_text(updateStatment, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatment, 2, (mobileno as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatment, 3, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatment, 4, Int32(id))
            
            
            if sqlite3_step(updateStatment) == SQLITE_DONE{
                print("Update successfully")
            }else{
                print("Could not delete")
            }
        }else{
            print("update statement could not be prepared")
        }
        sqlite3_finalize(updateStatment)
    }
}
