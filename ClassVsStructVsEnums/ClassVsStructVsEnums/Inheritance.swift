//
//  Inheritance.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 02/02/23.
//

import UIKit

class Inheritance: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = myclass(name: "amber1", age: 30)
        
        //allow only in case when all properties are optional
        //let obj2 = myclass()
        
        let obj3 = subClass(name: "amber2", age: 31)
        obj3.childFunc()
        obj3.myParentClassFunction()
        obj3.myFuncToOverride()
        
        let obj4 = obj3
        obj4.name = "iram"
        print(obj3.name) //It will print iram because class are reference type, any changes making in obj4 will reflect in obj3
        
    }
}


class myclass {
    //class is an object with properties and methods
    //Class are reference Type
    //Class need initializer if properties are non optional
    //If all properties are optional then we don't need initializer at the time of object creation
    //class provide inheritance
    //Inheritance is overriding, it is feature to add additional functionality
    //inheritance allow to inherit all the behaviour of the parent class with some additional behaviour in  the child class
    //Inheritance enable us to define a class that takes all the functionality from parent class and allows us to add more. Method overriding occurs simply defining in the child class a method with the same name of a method in the parent class
    
    //Polymorphism (many-forms) is the ability for objects of different types to be treated as if they are the same common type. we achieve this in swift using inheritance
    
    var name:String
    var age: Int
    var hobby: String?
    
    init(name:String,age:Int) {
        self.name = name
        self.age = age
    }
    func myParentClassFunction(){
    }
    
    func myFuncToOverride(){
    }
}

class subClass: myclass {
    
    func childFunc(){ //New Child Class function addition
        let _ = name
        let _ = age
        myParentClassFunction() //parent class functions are accessible
    }
    
    override func myFuncToOverride() {
        //Override parent class function in child class
    }
    
}
