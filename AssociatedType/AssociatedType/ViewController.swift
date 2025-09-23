//
//  ViewController.swift
//  AssociatedType
//
//  Created by Ambreen Bano on 19/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appendingStrings()
        appendingInts()
        sorting()
    }
}

/*__________________________________________*/


//associated type is placeholder type for PROTOCOLS, to create generic protocols
protocol appendable {
    associatedtype Element
    func append(_ element: Element)
}

class IntArray: appendable {
    var collectionOFIntArray: [Int]
    
    init(array:[Int]){
        self.collectionOFIntArray = array
    }
    
    //Generic protocol method, associated type will be replace by Int
    func append(_ element: Int) {
        self.collectionOFIntArray.append(element) //default append method of array, our protocol with associated type show how array append is implemented internally
    }
}


class StringArray: appendable {
    var collectionOFStringArray: [String]
    
    init(array:[String]){
        self.collectionOFStringArray = array
    }
    
    //Generic protocol method, associated type will be replace by String
    func append(_ element: String) {
        self.collectionOFStringArray.append(element)
    }
}


extension ViewController {
    // append protocol is generic using associatedType so can be use for Strings/Int
    func appendingStrings(){
        let obj = StringArray(array: ["c","a","b"])
        obj.append("d")
        print(obj.collectionOFStringArray)
    }
    
    func appendingInts(){
        let obj = IntArray(array: [1,2,3])
        obj.append(4)
        print(obj.collectionOFIntArray)
    }
}


/*__________________________________________*/



protocol GenericForSorting: Comparable {
    associatedtype Element
    static var collection: [Element] {get}
}

struct MyModel1: GenericForSorting {
    let name: String
    
    static var collection: [MyModel1] { //Generic protocol computed property
        return [
            MyModel1.init(name: "Iram"),
            MyModel1.init(name: "Amber")
        ]
    }
    
    static func < (lhs: MyModel1, rhs: MyModel1) -> Bool {
        return lhs.name < rhs.name
    }
}

struct MyModel2: GenericForSorting {
    let age: Int
    
    static var collection: [MyModel2] {
        return [ MyModel2.init(age: 30),
                 MyModel2.init(age: 25),
                 MyModel2.init(age: 60),
                 MyModel2.init(age: 35)]
    }
    
    static func < (lhs: MyModel2, rhs: MyModel2) -> Bool {
        return lhs.age < rhs.age
    }
}

struct StringArrayModel: GenericForSorting {
    var value: String
    
    static var collection: [StringArrayModel] {
        return  [
            StringArrayModel.init(value: "b"),
            StringArrayModel.init(value: "c"),
            StringArrayModel.init(value: "a")
        ]
    }
    
    static func < (lhs: StringArrayModel, rhs: StringArrayModel) -> Bool {
        return lhs.value < rhs.value
    }
}

extension ViewController {
    func sortData<T:GenericForSorting>(data: [T]){
        let sortedData = data.sorted { $0 < $1 }
        print(sortedData)
    }
    
    func sorting(){
        self.sortData(data: MyModel1.collection)
        self.sortData(data: MyModel2.collection)
        self.sortData(data: StringArrayModel.collection)
    }
}
/*__________________________________________*/
