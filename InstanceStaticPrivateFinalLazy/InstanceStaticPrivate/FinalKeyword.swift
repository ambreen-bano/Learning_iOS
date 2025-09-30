//
//  FinalKeyword.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 02/02/23.
//

import UIKit

//Stored properties - can be static/final (var/let)
//Compiuted properties - can be static/final/class (var)
//Methods - can be static/final/class
//Class - can be final (static class is NOT allowed)

//Class - can be inherit/override
//Static/final - can NOT be inherit/override

//Class/Static - can be access using class/Struct/Enum Name
//Instance/final - can be access using class/Struct/Enum instance



//Final can be use for class/methods/properties (Can't use with Value type)
//Final can not override as it block the inheritance
//Final properties/methods required class instance to access it.

class FinalKeyword: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let obj = ourFinalClass()
        //Final class can not be inherit but all properties and methods are called on class instance only. like static properties it is not required class name to access it.
        obj.var1 = 1
        obj.var2 = 20
        obj.function1()
        
        StaticAndClassMembers.cFunc()
    }
}

/**************************************/

final class ourFinalClass: UIViewController {
    final var var1: Int = 0
    var var2: Int = 10
    
    final func function1(){
    }
    
    func function2(){
    }
}

//We can not inherit class if it is "final" class (class can't be static so if you want to avoid inheritance make it final class)
//class ourSecondClassOverride: ourFinalClass {
//
//}


//We can also Extend class if it is "final" class
extension ourFinalClass {
    
}


/**************************************/

//class is not final. so we can inherit this class
//Class properties and methods are final. those we can not inherit or override
//So final can be use to limit the access or blocking the inheritance/overriding of the property/methods/class according to the requiremnt


class ourPropertiesAreFinal: UIViewController{
    
    var instanceVariable: Int = 0
    final var finalVariable: Int = 0
    
    var computedProperties: Int {
        10
    }
    
    class var computedProperties2: Int {
        15
    }
    
    static var computedProperties3: Int {
        18
    }
    
    final var computedPropertyFinal: Int {
        20
    }
   
    final func functionIsFinal(){ }
    func function(){ }
    func function2(){ }
}

class ourSecondClass: ourPropertiesAreFinal {
    override var computedProperties: Int {
        100
    }
    
    override class var computedProperties2: Int {
        200
    }
    
    //Cannot Override Stored Properties
    //    override var instanceVariable: Int = 1
    
    //Cannot Override static Properties and Methods
    //static var computedProperties3: Int {
    //    18
    //}
    
    //Cannot Override Final Properties and Methods
    //    override var computedPropertyFinal: Int {
    //        200
    //    }
    //    final var finalVariable: Int = 0
    //    final func functionIsFinal(){
    //    }
    
    override func function() { }
    
    func whichFuncWillCall(){
        self.function() //it is define in subclass so subclass method will call
        self.function2() //it is not define in subclass so parent class method will call
        self.functionIsFinal() //we can not inherit but we can call final method of the parent class
    }
}
/**************************************/
