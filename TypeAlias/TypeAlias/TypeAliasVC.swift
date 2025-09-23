//
//  TypeAliasVC.swift
//  TypeAlias
//
//  Created by Ambreen Bano on 22/01/23.
//

import UIKit

//typealias is just a new name for redability
//typealias can use for closures name
//typealias can use for dictionary name
//typealias can use for tuples name

class TypeAliasVC: UIViewController {
    
    typealias MyNewTuple = (name: String, age: Int, studentClass: String)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentData(student: ("amber", 30, "FinalYear"))
        
        let errorData = returnErrorReasons()
        print("\(errorData.error)\n\(errorData.errorReason)")
        
        let errorData = returnErrorReasons1()
        print("\(errorData.0)\n\(errorData.1)")
        
        
        processServerData(data: ["key1" : "Amber", "key2" : 30])
        
        
        
        functionWithHandler(number: 10) {
            //Do Something
        } completionHandlerV: {
            //Do Something
        }
        
        
        functionWithHandler1(number: 10) { name, age in
            print(name + "\(age)")
        } completionHandler2: { str, val in
            print(str + "\(val)")
        }

        
        functionWithHandler1(number: 10, completionHandler1: nil) { str, val in
            print(str + "\(val)")
        }
        
        
        functionWithHandler3(number: 10) { lat, long in
            print("\(lat) \(long)")
        } completionHandler4: { newLat, newLong in
            print("\(newLat) \(newLong)")
            return newLat + newLong
        }
    }
    
    
    private func studentData(student: MyNewTuple) {
        let sName = student.name
        let sAge = student.age
        let sStudentClass = student.studentClass
        print("\(sName)  \(sAge)  \(sStudentClass)")
    }
}


// Tuples
extension TypeAliasVC {
    typealias MyNewReturnTypeTuple = (error: String, errorReason: String) //Use .error or .errorReason to access
    typealias MyNewReturnTypeTupleWithoutName = (String, String) //Use .0 or .1 to access
    
    private func returnErrorReasons() -> MyNewReturnTypeTuple {
        return ("This is Error", "No Internet")
    }
    
    private func returnErrorReasons1() -> MyNewReturnTypeTupleWithoutName {
        return ("This is Error", "No Internet")
    }
}

// Dictionary
extension TypeAliasVC {
    typealias JsonDataType = [String: Any]
    
    private func processServerData(data: JsonDataType) {
        if let value1 = data["key1"] as? String {
            print(value1)
        }
        if let value2 = data["key2"] as? Int {
            print("\(value2)")
        }
    }
}


// Closures without params
extension TypeAliasVC {
    typealias handler = () -> ()
    typealias handlerV = () -> (Void)
    
    private func functionWithHandler(number: Int, completionHandler: handler, completionHandlerV: handlerV) {
        if number > 0 {
            completionHandler()
            completionHandlerV()
        }
    }
}


// Closures with params
extension TypeAliasVC {
    typealias handler1 = (_ name:String, _ age: Int) -> (Void)
    typealias handler2 = (String,Int) -> (Void)
    
    private func functionWithHandler1(number: Int, completionHandler1: handler1?, completionHandler2: handler2) {
        if number > 0 {
            if let completion = completionHandler1 {
                completion("Amber", 30)
            }
            completionHandler2("Iram", 31)
        }
    }
}


extension TypeAliasVC {
    typealias handler3 = (_ lat: Int, _ long: Int) -> (Void)
    typealias handler4 = (Int, Int) -> (Int)
    
    private func functionWithHandler3(number: Int, completionHandler3: handler3, completionHandler4: handler4) {
        if number > 0 {
            completionHandler3(40, 50)
            let returnValue = completionHandler4(60, 70) //it has return type of int
            print(returnValue)
        }
    }
}
