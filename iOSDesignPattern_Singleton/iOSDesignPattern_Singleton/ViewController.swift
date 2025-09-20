//
//  ViewController.swift
//  iOSDesignPatterns
//
//  Created by Ambreen Bano on 23/08/25.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        MySingletonLog.shared.logMsg("This is my singleton class")
        testUsers()
    }
    
    func logging() {
        MySingletonLog.shared.logMsg("This logging function is hard to test as directly depend on the singleton class. We can't replace MySingletonLog with Mock for testing ")
    }
}



//Singleton Design Pattern
final class MySingletonLog { //final so no one can inherit also, single instance gurantee
    /* Singleton Pattern
     A Singleton is a design pattern where only one instance of a class is created during the entire app lifecycle, and it provides a global access in the app.
     Ensures only one instance of a class exists globally.
     Where used? (UserDefaults.standard, NotificationCenter.default, FileManager.default, UIApplication.shared, URLSession.shared)
     Hard to test as it is tightly coupled because of single instance - solution DI and protocols
     
     Inheritance - We can inherit singleton class as singleton subclass using required init() instaed of private init() but we should avoid inheritance because it is not good practice but we can do for testing as singleton class is tightly coupled and hard to test
     
     Pros -
     Easy access (global).
     Saves memory, no duplicates. (But ARC issue as singleton object life cycle is till app kill)
     use for - Good for managers (logging, network, cache).
     Instance is thread safe
     
     Cons -
     Due to global state (hard to test, tightly coupled).
     Hard to mock in unit testing.
     Misuse may make code less modular.
     Mutable Properties/Singleton class is not thread safe by default, need GCD serial or NSLock
     Only instance of the singleton class is thread safe by default due to static let initialization
     */
    
    
    /*Single shared instance, lifecycle = App killed
     static let == by default is lazy [static let initialize when first time access]
     Earlier in older versions we use dispatch_once for making instance thread safe. No longer needed.
     Now it is Thread Safe as "Static let" can not change as it is "let" And init is private so it is thread-safe. */
    
    static let shared: MySingletonLog = MySingletonLog()
    
    // private to prevent outside creation
    private init() {}
    
    func logMsg(_ msg: String) {
        print("Log Msg : \(msg)")
    }
}




/* Singleton Class Deallocation/reset */
class MySingletonWithResetOrDeallocation {
    //Should be private, this is for computed property
    private static var _shared: MySingletonWithResetOrDeallocation?
    
    /* Get-only Computed property, instance use by outside
     it is var but we can not initialize with new value from outside as init is private and it is var but no optional so can even set nil from outside */
    static var shared: MySingletonWithResetOrDeallocation {
        if let instance = _shared {
            return instance
        } else {
            return MySingletonWithResetOrDeallocation()
        }
    }
    
    private init() {}
    
    func logMsg(_ msg: String) {
        print("Log Msg : \(msg)")
    }
    
    static func resetOrDeallocate() {
        //should be static, so can call from outside on class name without shared instance
        //If need for some cases like for logout case
        MySingletonWithResetOrDeallocation._shared = nil
    }
}



/* Singleton Class - class instance is by default Thraed Safe but instance/properties variables are not thread safe
 Mutable properties are not Thread safe by default, we need to make it thread safe
 Using GCD concurrent queue with barrier
 Best to use for performance */
class MySingletonLogWithThreadSafeGCD {
    static let shared: MySingletonLogWithThreadSafeGCD = MySingletonLogWithThreadSafeGCD()
    private init() {}
    
    let myQueue = DispatchQueue(label: "MyQueue", attributes: .concurrent)
    var result: Int = 0
    
    func increment() {
        //Only one write can happen at a time. As it is barrier. It ensure no other task will run when it runs it's block on queue
        myQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else {return}
            self.result = self.result + 1
        }
    }
    
    func read(handler: @escaping (Int) -> Void) {
        //Multiple reads can happen in parallel
        myQueue.async { [weak self] in
            guard let self = self else { return }
            return handler(self.result)
        }
    }
}



/* Singleton Class - NSLock to make it Thraed Safe
 Mutable properties are not Thread safe by default, we need to make it thread safe
 Using NSLock on mutating properties
 NSLock is slow than GCD */
class MySingletonLogWithThreadSafeNSLock {
    static let shared: MySingletonLogWithThreadSafeNSLock = MySingletonLogWithThreadSafeNSLock()
    private init() {}
    
    let lock = NSLock()
    var result: Int = 0
    
    func increment() {
        //Only one write at a time
        lock.lock()
        result = result + 1
        lock.unlock()
    }
    
    func read() -> Int {
        //Only one read at a time, slower than GCD
        lock.lock()
        let new = result
        lock.unlock()
        return new
    }
}





/* Singleton Class Inheritance
 We should avoid this but if it is required for any scenario then only use. Because it breaks the rule of singleton class [1 instance], as it has 2 instances [base class instance and child class instance] */

class MySingletonBaseClass {
    private static var _shared: MySingletonBaseClass? //It should be rivate
    
    class var sharedBase: MySingletonBaseClass { //Use computed property
        if let instance = _shared {
            return instance
        } else {
            return MySingletonBaseClass()
        }
    }
    
    required init() { } //No private init() for inheritance
}

class MySingletonInheritance: MySingletonBaseClass {
    private static var _shared: MySingletonInheritance?
    
    override class var sharedBase: MySingletonBaseClass {
        if let instance = _shared {
            return instance
        } else {
            return MySingletonInheritance()
        }
    }
    
    required init() {
        super.init()
    }
    
}





/* Singleton Class Testing - DI so we can Mock own singleton class for testing */

/* 1. Protocol */
protocol methodsForTestingViaSigleton {
    func callAPI()
}


/* 2. Production Singleton Class */
class MySingletonProduction: methodsForTestingViaSigleton {
    static let shared = MySingletonProduction()
    private init() {}
    
    func callAPI() {
        //Real API Call
        print("Real API Method Called")
    }
}

/* 3. Use Singleton Class, inside project using DI to inject singleton class instaed of directly using singleton.
 Create Protocol
 Create Singleton and Adop Protocol
 Craete protocol instance and Inject Protocol inside other modules to use
 Create Mock class which Adopts Protocol for testing */
class Users {
    private let dependencyInject: methodsForTestingViaSigleton //Protocol Inject so we can test using Mock
    
    init(inject: methodsForTestingViaSigleton = MySingletonProduction.shared) {
        dependencyInject = inject //Injecting singleton at the initialization (constructor init)
    }
    
    func userFetch() {
        dependencyInject.callAPI()
    }
}


/* 4. Mock Class for Testing */
class MySingletonMock: methodsForTestingViaSigleton {
    func callAPI() {
        //Mock data for API Call to test
        print("Mock Testing Method Called")
    }
}


/* Unit Test to Inject Mocked class */
func testUsers() {
    let user = Users(inject: MySingletonMock()) //Injecting Mock class for testing
    user.userFetch()
}
