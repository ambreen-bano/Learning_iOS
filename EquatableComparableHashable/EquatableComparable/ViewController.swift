//
//  ViewController.swift
//  EquatableComparable
//
//  Created by Ambreen Bano on 19/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*__________Equatable_____________*/
        let obj1 = MyModel(name: "Amber", age: 30)
        let obj2 = MyModel(name: "Iram", age: 30)
        //To Check == in custom objects we need to adopt Equatable protocol
        let isSame = obj1 == obj2
        print(isSame)
        
        
        let obj3 = MyModelWithCustomEquatable(id: 3, age: 30, name:"Amber")
        let obj4 = MyModelWithCustomEquatable(id: 4 , age: 30, name: "Iram")
        //It will check only id of the obj is same or not
        let isIDSame = obj3 == obj4
        print(isIDSame)
        /*__________Equatable_____________*/
        
        
        
        /*__________Comparable_____________*/
        let obj5 = MyComparableModel(id: 5, age: 30, name: "Amber")
        let obj6 = MyComparableModel(id: 6, age: 30, name: "Iram")
        //It will check only id of the obj is same or not
        let isIDSame_ = obj5 == obj6
        print(isIDSame_)
        
        let isIDlessThan_ = obj5 < obj6
        print(isIDlessThan_)
        /*__________Comparable_____________*/
        
        
        
        /*__________Hashable_____________*/
        let dict: [AnyHashable: String] = [
            MyModelHashable(id: "1") : "MyFirstValue",
            MyModelHashable(id: "2") : "MySecondValue"
        ]
        print(dict[MyModelHashable(id: "1")]!)
        /*__________Hashable_____________*/
        
    }
}



/*__________Equatable_____________*/
struct MyModel: Equatable {
    //Adopt Equatable protocol for == check (it will check == for EACH property of the object)
    let name: String
    let age: Int
}

struct MyModelWithCustomEquatable: Equatable {
    //Adopt Equatable protocol for == check (it will check == for each property of the object)
    //But if we want to check only one property of the object for == then need to override below method
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
   
    let id: Int
    let age: Int
    let name: String
}
/*__________Equatable_____________*/





/*__________Comparable_____________*/
struct MyComparableModel: Comparable {
    //only < and == need to implement, other > >= <= will automatically worked with Comparable
    //So, if using Comparable then don't need to implement Equatable
    
    static func < (lhs: MyComparableModel, rhs: MyComparableModel) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    //Adopt Equatable protocol for == check (it will check == for each property of the object if == not override)
    let id: Int
    let age: Int
    let name: String
}

/*__________Comparable_____________*/






/*__________Hashable_____________*/
struct MyModelHashable: Hashable {
    //Hashable - Produce hasher using hashvalue
    //if we are using it in dict for key ( eg.AnyHashable ) then need to adop Hashable protocol
    let id: String
}
/*__________Hashable_____________*/
