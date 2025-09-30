//
//  LazyKeyword.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 02/02/23.
//

import UIKit

class LazyKeyword: UIViewController {
    
    //Lazy can be use ONLY on var declarations (only var properties) (Can NOT be let)
    //Lazy can be use ONLY for var Stored Properties. (can not use for computed properties)
    //A lazy var is a property whose initial value is not calculated until the first time it's called. Lazy property will initialize/created only at the time of first access. it will NOT create at the time of class object creation/initialization
    //lazy properties will calculate value once access and store in the variable. Not calculating every time when we access it
    //computed properties also not initialize at the time of object creation, it will also initialize at the time of access/call but difference from lazy is that, it will calculate value, every time when we call/access it.
    //lazy can be use or good for big expensive calculations so it will increase performance as calculated once only and then stored value.
    
    
    var count: Int = 0
    //lazy can be stored properties and property initializer
    lazy var var2: Int = 10
    
    lazy var shared = LazyKeyword() //stored property
    
    //when using = and () then it is property initializer (This not computed properties, this is stored property only with property initialization)
    //Lazy can be use only with property initializer
    lazy var myLazyP:Int = {
        //we can use self. inside lazy stored properties and computed properties because they are not initialize at the time of object initialization/creation
        for i in 1...40000 { //Heavy calculation, goof performace with lazy
            self.count = self.count + i
        }
        return self.count
    }()
    
    //Lazy can NOT be use with computed properties
    //    lazy var myLazyP:Int {
    //        return 0
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


class lazyExample: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //lazy property will not create at the time of creating instance obj of the class so increase performance as (avoiding calculation required in lazy properties at time of obj initilization)
        let obj = LazyKeyword()
        let obj1 = LazyKeyword()
        let obj2 = LazyKeyword()
        
        //When we use lazy property then only it will run or initialize
        //This time all the calculation will happen when we use it only one time calculate
        //Good to use for large calculations
        //Improve performance using lazy
        _ = obj.myLazyP
        obj.var2 = 20
    }
}
