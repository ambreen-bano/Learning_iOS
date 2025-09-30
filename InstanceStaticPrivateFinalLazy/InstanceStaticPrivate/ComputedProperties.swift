//
//  ComputedProperties.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 02/02/23.
//

import UIKit


//1. Use for encapsulation to hide or limit access to private property or calculation or methods from outside class
//2. Use for some repeated or complicated calculations. so it will be at one place and hidden from outside also to calculate again on each instance obj

//Stored properties can NOT define in extensions and can not be inherit/Override in another class
//Computed properties can define in extensions and can be inherit/Override in another class

//Stored properties - calculate once and store it
//Computed properties - calculate everytime we access, it has no storage (it is use to compute other properties)

//Stored properties - can have initial value in case of observers [ = 0 { //Initial value ONLY in case of observers } ]
//Computed properties - can NOT have initial value [ can have only {} ] No = in computed properties

//Stored properties - can have [  = {//creation of statements}() ]
//Computed properties - can have [  {//getter setter}  ]

//Stored properties - can have property observers willSet{} didSet{}. Can NOT have get{} set{}
//Computed properties - can have getter and setter get{} set{}.  Can NOT have willSet{} didSet{}

//Stored properties - can be let or var
//Computed properties - can be ONLY var

//Enum don't have stored properties


//Get Set only in computed properties allowed (stored properties can not have getter setter)
class ComputedPropertiesClass {
    
    //Hide these stored properties from outside class using computed properties as encapsulation
    private var workingHours: Int = 0
    private var workingDays: Int = 0
    var optionalName : String?
    var mandatoryName : String
    
    //Get Only Computed property, we can not set value from outside
    var computedPropertiesSalary: Int {
        return workingDays * workingHours * 1000
    }
    
    //Get Only Computed property, we can not set value from outside
    var computedPropertySalaryExpected: Int {
        get {
            return 10000
        }
    }
    
    //Writing get{ } and return is optional in get-only property
    var computedPropertyGetOnly: Int {
        10000
    }
    
    
    //Get/Set computed property, we can set value from outside
    //computed properties can be use to set or modify private properties values which is hidden from direct interaction from outside, like encapsulation
    //get only property is possible but set only property is not possible
    var getSetDays: Int {
        get {
            return workingDays //providing encapsulation for private workingDays property
        }
        set {
            //can be use to perform some calculation on the basis of new value
            workingDays = newValue + 2
        }
    }
    
    var experience: Int {
        //Each employee experience can be directly read from this computed property. No need to calculate again and again using instance object of the class and its variables.
        return workingDays * workingHours
    }
    
    //   computed property is get and set or get only. then, we can NOT have it's initial value as shown below "0"
    //    var experience: Int = 0 {
    //         return workingDays * workingHours
    //    }
    
    
    //Initializer for class instance
    //Initializer mandatory for non optional properties
    //Stored property initialize at the time of initialization
    //Computed property are not initialize at the time of object initialization
    init(hours: Int, days: Int, mandatoryName: String){
        workingDays = days
        workingHours = hours
        self.mandatoryName = mandatoryName
    }
}



class example: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //By default properties and methods are internal. we can use them anywhere inside our module
        let internalAccessControlTestingObj = PublicOpenPrivateFilePrivateInternal()
        _ = internalAccessControlTestingObj.defaultVar
        
        
        let obj = ComputedPropertiesClass(hours: 12, days: 10, mandatoryName: "Amber")
        
        //private property, can not set value from outside
        //obj.workingDays = 5
        //Get Only property, can not set value
        //obj.computedPropertiesSalary = 200
        let salary = obj.computedPropertiesSalary
        print(salary)
        //Get/Set property, we can set value
        //Can be use to modify private stored properties, which are hidden from direct interaction from outside
        obj.getSetDays = 5
        
        
        //Each employee experience can be directly read from this computed property. No need to calculate again and again using instance object of the class and its variables.
        // obj1.experience = obj1.workingDays * obj1.workingHours
        // obj2.experience = obj2.workingDays * obj2.workingHours
        // obj3.experience = obj2.workingDays * obj2.workingHours
        let experience = obj.experience
        print(experience)
    }
}
