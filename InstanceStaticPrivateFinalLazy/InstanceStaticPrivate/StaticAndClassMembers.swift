//
//  StaticAndClassMembers.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 23/01/23.
//

import UIKit

//Difference between static and class Var/Func - inheritance
//Static Stored and computed properties and methods can NOT be Override
//Class computed properties and methods can be Override (Class Stored properties are not allowed)
//Both Static and class members are access using class name only
//Static can only be use for properties and methods. for class we can not use static KW (final use for class)
//There are no Static classes in Swift

class StaticAndClassMembers: UIViewController {
    
    //Static Stored/computed properties and methods
    static var sName: String?
    static var scName: String {
        return "StaticName"
    }
    static func sFunc(){ }
    
    //Class Computed properties and methods
    //Class var cName: String? //class stored properties not supported - due to inheritance
    class var ccName: String { //class computed properties can only define
        return "ClassName"
    }
    class func cFunc(){ } //class kw providing global access and inheritance also. but static provides only global access
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Both are access using class name only
        let _ = StaticAndClassMembers.sName
        StaticAndClassMembers.sFunc()
        StaticAndClassMembers.cFunc()
    }
}



class inheritClass: StaticAndClassMembers {
    //Can not Override static properties and methods
    //static var sName: String?
    //static func sFunc(){
    //}
    var sName: String? //this is new variable of the class, not inherit from super class
    
    
    //Can Override Class properties and methods
    override class var ccName: String { //class computed properties can only define
        return "Name"
    }
    override class func cFunc() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

