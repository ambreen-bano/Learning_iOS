//
//  Question1.swift
//  InterviewPractice_1
//
//  Created by Ambreen Bano on 18/08/25.
//

import Foundation
import UIKit


class Question1 {
    
    func runQuestions() {
        print("+++++++++++++++\(varStoredProperty)")
        varStoredProperty = 10
        print("+++++++++++++++\(varStoredProperty)")
        
        
        print("+++++++++++++++\(storedProperty_)")
        storedProperty_ = 12
        print("+++++++++++++++\(storedProperty_)")
        
        
        print("+++++++++++++++\(storedPropertyWithObservers)")
        storedPropertyWithObservers = 50
        print("+++++++++++++++\(storedPropertyWithObservers)")
        
        //computedPropertyGetOnly = 100 //GET ONLY
        
        print("+++++++++++++++\(storedPropertyWithLazy)")
        storedPropertyWithLazy = 1
        print("+++++++++++++++\(storedPropertyWithLazy)")
        
        width = 1
        print("+++++++++++++++\(storedPropertyWithLazy_)")
        storedPropertyWithLazy_ = 5
        print("+++++++++++++++\(storedPropertyWithLazy_)")
        width = 10
        print("+++++++++++++++\(storedPropertyWithLazy_)") // VALUE Will NOT CHANGE AS IT IS LAZY,Value calculated ONLY ONCE
        
        
        methodDispatchTypes()
        methodDispatchTypesWithProtocols()
        myDynamicMemberLookupMethod()
        resultBuildMethodCall()
        myCapitalizeMethod()
        myPropertWrapperMethodWithDefaults()
        myPropertWrapperWithProjectedValue()
        myUserDefaultAccountRead()
        CopyOnWrite()
        
    }
    
    
    //Q.10 What is the difference between stored Properties, lazy stored Properties and computed properties?
    //Stored Property Initialize at the time of Object initialization.
    //Lazy or computed properties are NOT initialize at the time of Object initialization. They initialize at the time of access(first) in the code.
    
    let letStoredProperty: Int = 2 //Stored Property Initialize at the time of Object initialization
    var varStoredProperty: Int = 3
    var storedProperty_: Int = {
        5
    }()
    var storedPropertyWithObservers: Int = 0 {
        // get/set NOT Allowed
        // willSet/didSet Observers are Allowed with stored properties
        // () NOT Allowed and default value (= 0) is required
        willSet {
            print("+++++++++ \(newValue)")
        }
        didSet {
            print("++++++++++ \(oldValue), \(storedPropertyWithObservers)")
        }
    }
    
    
    
    
    var width: Int = 1
    var computedPropertyGetOnly: Int { //Computed Property NOT Initialize at the time of Object initialization
        // This is READ ONLY
        width * 2
    }
    var computedPropertyGetSet: Int {
        // let NOT Allowed
        // lazy NOT Allowed
        // get/set Allowed
        // Calculate every time when access, NO storage
        // Initialize when access first time, NOT initialize at the time of object initialization
        // willSet/didSet Observers are NOT Allowed with computed properties
        get {
            width * 2
        }
        set {
            width = newValue/2
        }
    }
    
    
    
    //    var storedProperty: Int = {
    //        width * 2 //self.width can NOT be use, because storedProperty is initialize at the time of object initialization
    //    }()
    lazy var storedPropertyWithLazy: Int = 2 //Lazy Stored Property NOT Initialize at the time of Object initialization
    lazy var storedPropertyWithLazy_: Int = {
        // let NOT Allowed
        // stored property only have = and () Allowed
        // Calculate ONCE and stored value, NOT calculate every time
        // Initialize when access first time, NOT initialize at the time of object initialization
        width * 2 //self.width can be use only on stored property id it is lazy, as storedProperty_ initalizarion is lazy
        
        //This block will execute ONLY ONCE.
    }()
    
}



//Q.9 Explain method dispatch in Swift (static, vtable, message dispatch).
//Static Dispatch (Compile Time) [struct/enum methods, final methods, static methods, private methods]
//Virtual Table Dispatch (runtime lookup) [override class methods]
//Message Dispatch (Objective C runtime lookup) [@objc dynamic methods] - KVO and swizzling methods

class MethodDispatchClass {
    static func myStaticFunc() {
        //Static Dispatch
    }
    
    final func myFinalFunc() {
        //Static Dispatch
    }
    
    func myOverrideFunc() {
        //Virtual Table Dispatch
    }
    
    @objc dynamic func myObjcDynamicFunc() {
        //Message Dispatch
    }
}

class MySubClass: MethodDispatchClass {
    override func myOverrideFunc() {
        //Virtual Table Dispatch
    }
    
    override func myObjcDynamicFunc() {
        //Message Dispatch
    }
}


func methodDispatchTypes() {
    let mySubClass: MySubClass = MySubClass()
    MySubClass.myStaticFunc() //Static Dispatch
    mySubClass.myFinalFunc() //Static Dispatch
    mySubClass.myOverrideFunc() //Dynamic Dispatch
    mySubClass.myObjcDynamicFunc() //Message Dispatch
    
    let methodDispatchClass: MethodDispatchClass = MethodDispatchClass()
    MethodDispatchClass.myStaticFunc() //Static Dispatch
    methodDispatchClass.myFinalFunc() //Static Dispatch
    methodDispatchClass.myOverrideFunc() //Dynamic Dispatch
    methodDispatchClass.myObjcDynamicFunc() //Message Dispatch
    
    let mySubClass_1: MethodDispatchClass = MySubClass()
    mySubClass_1.myFinalFunc() //Static Dispatch
    mySubClass_1.myOverrideFunc() //Dynamic Dispatch
    mySubClass_1.myObjcDynamicFunc() //Message Dispatch
}


//If you have a protocol with a default extension method, do you know whether Swift uses static or dynamic dispatch when calling that method?
protocol myProtocol : AnyObject {
    func myRequiredPMethod() //required Protocol method
    func myRequiredPMethod_1() //required Protocol method
}

extension myProtocol {
    func myRequiredPMethod() {
        //Default implementation
    }
    
    func myRequiredPMethod_1() {
        //Default implementation
    }
    
    func myHelperPMethod() {
        //Not required in Protocol implementation
    }
}

class MethodDispatchClassWithP: myProtocol {
    func myRequiredPMethod() {
        //override protocol implementation
    }
    
    // ❌ no myRequiredPMethod_1() implementation
}


func methodDispatchTypesWithProtocols() {
    let methodDispatchClassWithP: MethodDispatchClassWithP = MethodDispatchClassWithP()
    methodDispatchClassWithP.myHelperPMethod() //Static Dispatch
    methodDispatchClassWithP.myRequiredPMethod() //Static Dispatch, type is MethodDispatchClassWithP
    methodDispatchClassWithP.myRequiredPMethod_1() //Static Dispatch, type is MethodDispatchClassWithP
    
    let methodDispatchClassWithP_1: myProtocol = MethodDispatchClassWithP()
    methodDispatchClassWithP_1.myHelperPMethod() //Static Dispatch
    methodDispatchClassWithP_1.myRequiredPMethod() //Dynamic Dispatch, type is myProtocol
    methodDispatchClassWithP_1.myRequiredPMethod_1() //Dynamic Dispatch, type is myProtocol
}


//Q.8 What is final keyword in Swift? Why use it?
//Final class -> can not subclass
//Final method/Property -> Can not override
//Final provide static dispatch -> faster, increase performance
//Final class eg - use for utility or API calling classes, where inheritance is not required.
//Better to make classed final until inheritance is required
//UIView,UIButton - inheritance is required
//In Large codebase, if all classes are final then it will provide fast better performance, only make non final class if inheritance is required.

final class myFinalClass {
    var myProperty : Int = 0
}
//class mySubClass: myFinalClass {
//    // myFinalClass can not be subclass
//}



class myClassWithFinalM {
    final var myFinalStoredProperty : Int = 0
    var myStoredProperty : Int = 0
    
    final var myComputedFinalProperty : Int {
        myStoredProperty * 2
    }
    
    var myComputedProperty : Int {
        myStoredProperty * 2
    }
    
    final func myFinalMethod() {
        //Static dispatch
    }
    
    func myOverrideM() {
        //Dynamic dispatch
    }
}
class mySubClass: myClassWithFinalM {
//    Final/Non-Final all types of Stored prperties can not be override, ONLY Computed property can be override
    
    
//    override var myComputedFinalProperty: Int {
//    //Can not override final computed property
//        10
//    }
    override var myComputedProperty: Int {
        10
    }
    
    
//    override func myFinalMethod() {
//        //Can not override Final Method
//    }
    
    override func myOverrideM() {
        
    }
}




//Q.7 What is @dynamicMemberLookup and @resultBuilder?
// dynamicMemberLookup Swift attribute that allows access to properties/methods dynamically at runtime via subscript without compile time property
// If compiler doesn't find compile time property then it will call subscript
// dynamicMemberLookup is dynamic property access using dot syntax


@dynamicMemberLookup
class myDynamicMemberLookupClass {
    
    var myDict : [String:Int]
    var myCompileTimeProperty : String
    
    subscript(dynamicMember key : String) -> Int { //subscript Method is Mandatory for @@dynamicMemberLookup
        return myDict[key] ?? 0
    }
    
    init(myDict: [String : Int], str: String) {
        self.myDict = myDict
        self.myCompileTimeProperty = str
    }
 
}

func myDynamicMemberLookupMethod() {
    let myLookupClass = myDynamicMemberLookupClass(myDict: ["key1": 1, "key2": 2], str: "MyStr")
    let key1 =  myLookupClass.key1 //Dot Syntax eg. SwiftUI
    print("+++++++++++++\(key1)")
   
    let key2 =  myLookupClass.key2
    print("+++++++++++++\(key2)")
    
    let str = myLookupClass.myCompileTimeProperty
    print("+++++++++++++\(str)")
    
    let myDoesNotExsistProperty = myLookupClass.myDoesNotExsistProperty
    // dot syntax property "myDoesNotExsistProperty" dosen't exsist, it will check compile time propert is not there then it will call subscript, there also key not found so it will return default value
    print("+++++++++++++\(myDoesNotExsistProperty)")
    
}


//@resultBuilder is use to combile result. Like Ints can be added, Strings can be concatinated or return in [Strings] etc.
//In SwiftUI @ViewBuilder is @resultBuilder, which combiles multiple views as result. VStack is @ViewBuilder

@resultBuilder
class myResultBuilderClass { //This @resultBuilder will use are property wrapper
    static func buildBlock(_ components: Int...) -> Int { //buildBlock Method is Mandatory for @resultBuilder
        var addition = 0
        for component in components {
            addition = addition + component
        }
        return addition
    }
}

func additionOfInts(@myResultBuilderClass adds: () -> Int) -> Int {
    return adds()
}

func resultBuildMethodCall() {
    let output = additionOfInts {
        1
        2
        3
        4
        5
    }
    print("++++++++++++\(output)")
}




//Q.6 Explain @autoclosure. When is it useful?
//@autoclosure use when parameters are expressions. @autoclosure automatically wrap the expression into {}
//@autoclosure gives lazy evaluation. closure will not evaluated/computed until its is call, increase performance
//@autoclosure gives lazy evaluation so, useful for Logging, Error handlings.[particular case of error will call at a time. so only that closure will be computed and executed at a time]


func myAutoClosureMethod(log: @autoclosure ()->String, isProduction: Bool) {
    if isProduction {
        let logStr = log() //This log Closure will evaluated only if isProduction true and then log() is evaluated and executed
        print("+++++++\(logStr)")
    } else {
        //Log Closure will Not evaluated in this case
    }
}

func callMyAutoClosureMethod() {
    //myAutoClosureMethod(log: { 3>2 } , isProduction: false) // {} braces required without @autoclosure
    myAutoClosureMethod(log: "This is my Log" , isProduction: false)
}




//Q.5 What are property wrappers in Swift? Example?
//@propertyWrapper allow us to attach common logic/wrapper for properties [Provide reusability of the common logic]
//@propertyWrapper provides Encapsulation, wrapper/logic is hidden
//@propertyWrapper type must have: wrappedValue -> the actual value stored.
//Example of property wrappers @state @Published in swiftUI


@propertyWrapper
class Capitalize {
    var value : String
    var wrappedValue: String { //wrappedValue computed property is Mandatory for @propertyWrapper
        get {
            value
        }
        set {
            value = newValue.uppercased()
        }
    }
    
    init(wrappedValue: String) {
        self.value = wrappedValue
    }
}

class myName {
    @Capitalize var name: String = ""
}

func myCapitalizeMethod() {
    let myNameObjc = myName() //Not able to initialize Property wrapper properties (name) here.
    myNameObjc.name = "ambreen"
    print("++++++++\(myNameObjc.name)")
}


@propertyWrapper
class propertWrapperWithDefaults {
    var width : Int
    var height : Int
    var value : Int
    
    var wrappedValue: Int { //wrappedValue computed property is Mandatory for @propertyWrapper
        get {
            value
        }
        set {
            value = width * height * newValue
        }
    }
    
    init(wrappedValue: Int, width: Int, height: Int) {
        self.width = width
        self.height = height
        self.value = wrappedValue
    }
}

class Area {
    @propertWrapperWithDefaults(width: 2, height: 5) var areaValue: Int = 0
}

func myPropertWrapperMethodWithDefaults() {
    let areaObj = Area()
    print("++++++++++++++++\(areaObj.areaValue)")
    areaObj.areaValue = 2
    print("++++++++++++++++\(areaObj.areaValue)")
}



@propertyWrapper
class propertWrapperWithProjectedValue {
    var value : Int
    
    var wrappedValue: Int { //wrappedValue computed property is Mandatory for @propertyWrapper
        get {
            value
        }
        set {
            value = newValue * 2
        }
    }
    
    var projectedValue: Int {//If projectdValue computed property is define then it can be access using symbol $
        value + 1
    }
    
    init(wrappedValue: Int) {
        self.value = wrappedValue
    }
}

class ProjectedValue {
    @propertWrapperWithProjectedValue var projValue: Int = 0
}

func myPropertWrapperWithProjectedValue() {
    let projectedValueObjc = ProjectedValue()
    print("++++++++++++++++\(projectedValueObjc.projValue)")
    projectedValueObjc.projValue = 2
    print("++++++++++++++++\(projectedValueObjc.$projValue)")
}



@propertyWrapper
class userDefaultsWrapper <T>{
    var key : String
    var defaultValue: T
    
    var wrappedValue : T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

class myUserDefaultAccount {
    @userDefaultsWrapper(key: "name", defaultValue: "guest") var name: String
}

func myUserDefaultAccountRead() {
    let myUserDefaultAccountObjc = myUserDefaultAccount()
    myUserDefaultAccountObjc.name = "safia"
    print("++++++++++++\(myUserDefaultAccountObjc.name)")
    myUserDefaultAccountObjc.name = "amberBano"
    print("++++++++++++\(myUserDefaultAccountObjc.name)")
}




//Q.4 What is Copy-on-Write in Swift?
//Swift Collections [Array Dictionary set Strings] are value types provides Copy on Write
//Coping large data normally is expensive. So, Swift doesn't copy data when collection is assign to another variable. They access shared memory
//Copy is made only when any one is mutating.


func CopyOnWrite() {
    
    var a = [1,2,3]
    var b = a //a,b both have shared memory. they are value type but data is not copy yet
    b[1] = 6 //b is mutating. so, now data is copied
    
    print("++++++++\(a)")
    print("++++++++\(b)")
    
}


//Q.3 Difference between weak and unowned references?
