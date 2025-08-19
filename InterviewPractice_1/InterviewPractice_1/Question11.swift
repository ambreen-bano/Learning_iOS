//
//  Question11.swift
//  InterviewPractice_1
//
//  Created by Ambreen Bano on 17/08/25.
//

import Foundation
import UIKit
import SwiftUI

//What is UUID?
//In Swift, a UUID (Universally Unique Identifier) is represented by the UUID struct from the Foundation framework. It is a 128-bit value designed to be globally unique, meaning the probability of two identical UUIDs being generated independently is extremely low.
//UUIDs are commonly used in Swift for:
//1 Unique Identifiers: Assigning unique IDs to objects, data records, or users in applications and databases.
//2. File Naming: Generating unique filenames to prevent collisions.
//3. Session Management: Creating unique session IDs for user sessions.

//import Foundation
//let newUUID = UUID()
//print(newUUID) // Example output: 8D7F9B1E-C6A2-4E0D-9B8C-5F1A2B3C4D5E


class Question11 {
    
    func runQuestions() {
        var value1 = 10
        var value2 = 12
        swap(a: &value1, b: &value2)
        print("++++++++\(value1) \(value2)")
        
        var str1 = "abc"
        var str2 = "def"
        swap(a: &str1, b: &str2)
        print("++++++++\(str1) \(str2)")
        
        add(a: 1, b: 2)
        add(a: 1.5, b: 2.4)
        
        myGenericStruct(item: "abc")
        myGenericStruct(item: 123)
    }
}



//Q.11 What are opaque types (some) vs generics (<T>)
//Generics helps to write REUSABLE code using type T.
//Generics can be methods/Class/Struct
//Caller of the method controls the type
//Thread safe and compile time

//Can we use Any at place of generic?
//Yes, but Any required run time type casting which is expensive and can crash

func swap<T>(a: inout T, b: inout T) {
    let temp = a
    a = b
    b = temp
}

func add<T: Numeric>(a: T, b: T) -> T { //Generic must confirm to a protocol Numeric, can't use for strings
    return a + b
}

struct myGenericStruct<T> {
    var item : T
}


//Opaque some type
//Function returns some opaque type to caller which conforms to some protocol.
//Function knows the actual type but it is HIDDEN from caller
//Thread safe and compile time

protocol Animal {
    func speak()
}

class Cat : Animal {
    func speak() {
    }
}

class Dog: Animal {
    func speak() {
    }
}

func myAnimal() -> some Animal {
    //Compiler knows at compile time that type is Dog but caller knows type is Animal
    let dog = Dog()
    dog.speak()
    return dog
}

//SWiftUI with Opaque type
func myOpaqueType() -> some View {
    VStack {
        Text("myText")
        Button("MyBUtton") {
        }
    }
}


//Q.12 What are protocol extensions and default implementations?
//Protocol are blueprint of methods/properties (No Code).
//Protocols extension allow us to define default implementation of the methods and we can implement some extra helper or utility methods, these methods are available to all who adopts this protocol.
//Protocol provides flexibility, instead of HARDCODING some class type, we can use protocol type and whoever adopts this protocol type, can use at type place.
//Protocol Provide MULTIPLE INHERITANCE, we can inherit behaviours from multiple protocols(can't do with classes)
//Protocols provide MOCK TESTING
//Protocols provide REUSABILITY

//If protocols are so powerful, why not just always use protocols instead of classes?
//Protocols are abstraction blueprint, has no storage, can't have stored properties
//Protocols can not maintain object life cycle (ARC)
//Protocols can't prevent conflicting implementation,(Class has super methods override rule)
//protocol A { func foo() }
//protocol B { func foo() }
//
//struct Test: A, B {
//    func foo() { print("??") } // must unify both
//}




protocol myTestProtocol {
    func funcMandatory()
    func funcWithDefultImplementation()
}

extension myTestProtocol {
    func funcWithDefultImplementation() {
        //Default Implementation of the protocol method
        //funcWithDefultImplementation this is not mantatory to implemented by all who adopts myTestProtocol
    }
    
    //    func funcMandatory() {
    //        //No Default Implementation of the protocol method
    //        //funcMandatory this is mantatory to implemented by all who adopts myTestProtocol
    //    }
    
    
    func helperMethod() {
        //In extensions we can define some helper utility methods which is available to all types who adopt this protocol
    }
}



//Q.13 Can enums conform to protocols?
//Yes enums/struct adopt protocols

enum myTestEnum: Animal {
    
    case cat
    case dog
    
    func speak() { //protocol method implementation
        switch self {
        case .cat:
            print("cat case")
        case .dog:
            print("dog case")
        }
    }
}



//Q.14 What’s the difference between inout, mutating, and self reassignment?

func mySwap(val1: inout Int, val2: inout Int) {
    //inout - pass by reference, it is use to modify actual caller variables directly
}

struct myTestStruct {
    var testVar: Int
    
    mutating func modifyStructProperties() {
        //mutating - we can modify self properties only if function marked as mutating
        //mutating is kind of mutation permission, because struct/enum are value type, changes in properties causes creating copy of the struct/enum
        self.testVar = 10
        
        //Self reassignment - means we can assign self new instance of the self.
        //We can create new instance only inside mutating function
        self = myTestStruct(testVar: 5)
    }
}

//What is the difference between self and Self ?
// self - current instance object
// Self - current instance Type

//mutating func resetAll() -> Self {
//    self.testVar = 1
//    return myTestStruct(testVar: 0)
//}




//Q.15 What’s new in Swift 5.5+ regarding concurrency?
// Async/await, TaskGroup, Actor, Structured Concurrency


//Task {} block is Asynchrous but it is on main thread or background thread?
//Task {} block does not always mean background thread — it depends on where you launch it.


//Outside @MainActor context
//Task {
//    // On Background thread
//}
//

// Inside MainActor context
//@MainActor
//func updateUI() {
//    Task {
//        //On main thread
//    }
//}


//What is Async/await?
//Async/await is use for Asynchronus work
//Async - make the function async
//await - pause the execution until async task is finished
//try/await - Error handling
//It is structed concurrency
//Code look/feel like clear and synchronous but it is asynchrounous(redability increase)

//Before Async/await we have dispatchQueue and callbacks handling for Asynchronous work
//CALLBACK hell, NESTING statements, ERROR handling was difficult
//It provides unstructured concurrency


func myAsynchrounousWork() async {
    //API Call
}

func myAsyncWork() {
    Task { // Async methods we can't call from Non-Async, that's why using Task{}
        await myAsynchrounousWork() //await pause execution until it is completed
        print("Next set of task") //This will execute once above line of code task completed
    }
}



func myAsyncWorkWithThrows() async throws -> String {
    //API Call and
    return ""
}

func myAsyncWorkWithThrows() {
    Task {
        do {
            _ = try await myAsyncWorkWithThrows() //try then do and catch block is required
            // _ = try? await myAsyncWorkWithThrows() //try? then catch block is not required
        } catch {
            
        }
    }
}


//try? → Returns optional, returns nil if error occurs
//try! → Crashes if error occurs (use only when you are sure no error will happen)
//Use try? for optional results, try! only when safe.
//checkNumber is having some return type
    //let result1 = try? checkNumber(-5) // result1 = nil if error
    //let result2 = try! checkNumber(-5) // CRASHES if error




//What is sequential and concurrent concurrency with Async/await?
//Async/await - Sequential concurrency (Task execution is serial)
//Async let - Concurrent concurrency (Task execution is in parallel)
//use sequential when task are dependent on each other and sequence of execution matters
//use concurrent when task are independent, it will be FAST execution

func myAsynchrounousWork1() async -> Int {
    //API Call
    return 1
}

func myAsynchrounousWork2() async -> Int {
    //API Call
    return 2
}

// await provides squential execution
func mySequentialAsyncWork() {
    Task {
        let output1 = await myAsynchrounousWork1() //await pause execution until it is completed
        let output2 = await myAsynchrounousWork2() //once above async task completed then this one will start
        print("task executed in sequence, order of the task completion is fixed")
    }
}

// async let, provides concurrent execution, task are executed in parallel at the same time, independently
// async let, number of task are fixed and known at compile time
// async let, output can be await as needed(order is can be arrange according to the need)
func myConcurrentAsyncWork() {
    Task {
        async let output1 = myAsynchrounousWork1() //This task execution started and not blocking next line of code
        async let output2 = myAsynchrounousWork2() //This task execution started also started in parallel
        print("task executed in parallel, independently, concurrently, order of the task completion is NOT fixed")
        let numb1 = await output1 //Now it pause execution until we get output of task 1
        let numb2 = await output2 //Once we get output of task 1, it pause execution until we get output of task 2
        print("once all ouput received then it will execute")
    }
}


//Q.16 What is an Actor in Swift? Why introduced?
//Actor is refernec type like class
//Inside Actor all is Asynchrounous
//Inside Actor all mutate states are thread SAFE, Only 1 task can access state at a time due to this it prevent race condition
//Actor is use to provide thread safty in concurrent environment
//Actor methods call from outside requires await
//Actor doesn't support inheritance

actor MyActor {
    var myState: Int = 0 //property is thread safe, inside actor only one task can use this property at a time to prevent data race condition
    
    func add(val: Int) {
        myState = myState + val
    }
    
    func subtract(val: Int) {
        myState = myState - val
    }
}

func myActorCall() async {
    let myActor = MyActor()
    await myActor.add(val: 5) //await is required for calling Actor methods
}



//Q.17 How do you cancel a Task in Swift Concurrency?
//Task { }
//Every Task has cancel flag
//First Cancel task as task.cancel()
//Check inside task for cancellation and throws error or stop work
//We can check task cancellation using checkCancellation or isCancelled
//In structured concurrency, if parent task cancel then all it's child task will automatically cancelled by swift.

func mytask1() async throws {
    for i in 0...5 {
        try Task.checkCancellation() //try is throws and function is also throws so don't need do catch
        print(i)
    }
}

func mytask2() async throws {
    for i in 0...5 {
        if Task.isCancelled {
            print("task is cancelled")
            return
        } else {
            print(i)
        }
    }
}

let myParentTask = Task {
    //This is parent task
    do {
        try await mytask1()
        try await mytask2()
    } catch {
        print("task cancelled")
    }
}

func cancelMyParentTask() {
    myParentTask.cancel()
}



//Q.18 Difference between async let vs TaskGroup?

//TaskGroup --
//It is a way of executing MULTIPLE task CONCURRENTLY and DYNAMICALLY
//It creates task group
//Adding child task inside group dynamically (at run time)
//All child task are structured inside parent task
//Provide structured concurrency
//Ouput order is NOT fixed

//"hello" → instance of String
//String.self → the type object (metatype) of String
//String.Type → the type of that type object
    //let type: String.Type = String.self
    //print(type)  // "String"
    //JSONDecoder().decode(String.self, from: json)

func myChildTask1() async -> String {
    return "1"
}

func myChildTask2() async -> String {
    return "2"
}

func myTaskGroup() async {
    await withTaskGroup(of: String.self) { group in //Create task group
        //String.self is type of child task return value
        group.addTask {await myChildTask1()} //add task1 in group
        group.addTask {await myChildTask2()} //add task2 in group
        
        for await result in group { //group collect results as they complete. And gives output in the sequence task is completed, task completion order is random
            print("\(result)")
        }
    }
}


//async let vs TaskGroup?
// For async let - number of task is fixed and known at compile time.
// For TaskGroup - number of task are not fixed can be added in loop at run time dynamically, not known at compile time
// For async let - output order can be await or arranged according to the need.
// For TaskGroup - output order is NOT fixed, random.

// Both provide concurrent execution of multiple task
// Both provide structured concurrency






//Q.19 How do you bridge async/await with Combine?
