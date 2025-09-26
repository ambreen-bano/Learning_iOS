//
//  ClassVsStructVsEnum.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 18/02/23.
//

import UIKit

class ClassVsStructVsEnum: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //when to use where -
        //If we need inheritance then use Class - eg. Custom UIButton
        //If we don't need inheritance then use Struct because it is light weight - eg. Data model
        
        //for classes. Even when its a constant let, only the reference is immutable. while the properties could be modified without issues
        let classObj = MyClass(name: "Amber", age: 30) // Class need to define initializer
        let anotherObj = classObj
        anotherObj.name = "Iram"
        print(classObj.name) //It will Print Iram because class are reference type
        
        //When a Struct is created as a constant (using let) , the whole instance is immutable. Which means we are not allowed to modify its properties
        let structObj = MyStruct(name: "Amber", age: 30) //Struct having Default Initializer
        //structObj.name = "Iram"   //Can not modift as it is let constant
        var anotherStructObj = structObj
        anotherStructObj.name = "Iram"
        print(structObj.name) //It will print Amber because Struct are Value Type
    }
}



class MyClass {
    //1. Class are reference Type they are NOT thread safe
    //2. Class are Heavy Weight
    var name: String
    var age: Int
    
    //3. Need to definie init specificly in class
    init(name:String, age:Int) {
        self.name = name
        self.age = age
    }
    
    func myClassMethod(){
        //4. Class Functions can modify self properties
        self.name = "New Name"
    }
    
    //5. Class having deinit method
    deinit {
        //call automatically when class is deallocating
    }
}

class MySubClass: MyClass {
    //6. Class Provide Inheritance
}

extension MyClass: Comparable {
    static func == (lhs: MyClass, rhs: MyClass) -> Bool {
        return true
    }
    
    //7. Class can adop protocols
    static func < (lhs: MyClass, rhs: MyClass) -> Bool {
        return true
    }
    
    //8. Class are not thread safe becuase it's reference type
}




struct MyStruct {
    //1. Struct are Value Type, they are thread safe
    //2. Struct are Light Weight
    var name: String
    var age:Int
    //3. No Need to define initializer, Struct provide init by default
    
    mutating func myStructMethod(){
        //4. Struct Functions can not modify self properties, need to add mutating KW
        self.name = "New Name"
    }
    
    //5. Struct don't have deinit because they are not reference type so they don't have reference count, they are not deallocating
    //    deinit {
    //
    //    }
}

//struct MySubStruct: MyStruct {
//6. Inheritance is not allowed in Struct (Only it can adopt Protoclos)
//}

extension MyStruct: Comparable {
    //7. Struct can adop protocols
    static func < (lhs: MyStruct, rhs: MyStruct) -> Bool {
        return true
    }
    
    //8. Struct are  thread safe becuase it's value type
}





//Enums
//1. value type
//2. Light weight
//3. Default Initializer
//4. Enum Functions can not modify self properties, need to add mutating KW
//5. no deinit
//6. no inheritance
//7. Enum can adop protocols
//8. thread safe
//9. stored properties are not allowed in Enums, only has computed properties

enum MySimpleEnum {
    //1. Enum are Value Type
    //2. Enum are Light Weight
    case iphone6
    case iphone11, iphone12
    
    //Note : Stored Properties are not allowed in enum (Struct and class has)
    //var name: String
    //Computed Properties
    var name : String {
        get {
            return "Amber"
        }
    }
    
    //3.Default Initializer
    
    mutating func stringValueOFtheEnum()-> String{
        //4. Enum Functions can not modify self properties, need to add mutating KW
        print(self.name)
        switch self {
        case .iphone6:
            return "iphone6"
        default:
            return ""
        }
    }
    //5. Enum don't have deinit because they are value type so they don't have reference count
    //    deinit{
    //
    //    }
}

//struct MySubSimpleEnum: MySimpleEnum {
//6. Inheritance is not allowed in Enum (Only it can adopt Protoclos)
//}

extension MySimpleEnum: Comparable, CaseIterable {
    //7. Enum can adop protocols
    static func < (lhs: MySimpleEnum, rhs: MySimpleEnum) -> Bool {
        return true
    }
    //8. Enum are  thread safe becuase it's value type
}

