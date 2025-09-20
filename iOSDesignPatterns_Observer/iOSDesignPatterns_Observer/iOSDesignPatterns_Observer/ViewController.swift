//
//  ViewController.swift
//  iOSDesignPatterns_Observer
//
//  Created by Ambreen Bano on 23/08/25.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    let customNotificationName = Notification.Name("MyNotificationName")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let travel = Travel()
        let bank = Bank()
        
        let authObserver = AuthObserver()
        authObserver.addObserver(observer: travel) //Auth Class observer
        authObserver.addObserver(observer: bank) //Auth Class observer
        
        authObserver.loginSuccess() //This will Notify observes of Auth Class observers
        
        personKVO_name() //KVO for name property
        
        ArrayPublisher().arrayPublisherSubscriber()
    }
    
}


/* Design Pattern - Observer Pattern, where class maintains list of observers and notifies them when class state changes.
 It is One to Many Communication pattern.
 Delegates → Is a specialized case of Observer with 1-1 communication.
 
 When to use - when there are 1 - many communication required
 
 Advantages -
 Good for decoupling modules. [Delegate is tight coupling]
 
 Drawbacks -
 Easy Memory leaks
 Too many notifications
 Hard to trace who is observing whom (spaghetti communication).
 
 Example -
 NotificationCenter → Keyboard show/hide notifications.
 Combine → SwiftUI data binding.
 KVO → Observing changes in AVPlayer, scrollView, (Storyboard and VC communicated interally using KVO)etc.
 
 */


protocol LoginObserver: AnyObject {
    func loginSuccess()
}

class AuthObserver {
    var authObservers: [LoginObserver] = [] //Keep track of observers
    let queue = DispatchQueue(label: "MyObserverQueue") //This serial and sync Queue required to make this class thread safe or can use NSLock also
    //If not using queue or NSLOck() then an observer could be removed while notification is happening causes crash.
    
    deinit {
        authObservers.removeAll() //To Avoid Memory leaks
    }
    
    func addObserver(observer: LoginObserver) {
        queue.sync {
            authObservers.append(observer)
        }
    }
    
    func removeObserver(observer: LoginObserver) {
        queue.sync {
            authObservers.removeAll { $0 === observer  } //Address/Reference match ===
        }
    }
    
    func loginSuccess() {
        queue.sync {
            //Do process and when Once login success we need to notify observers
            notifyObserversAfterloginSuccess()
        }
    }
    
    func notifyObserversAfterloginSuccess() {
        for observer in authObservers {
            //Notify All Observers
            observer.loginSuccess() //Too many notifications = performance overhead.
        }
    }
}

//Travel class adopt LoginObserver because it wants to observe loginSuccess
class Travel: LoginObserver {
    func loginSuccess() {
        //Do required after login success stuff
    }
}

//Bank class adopt LoginObserver because it wants to observe loginSuccess
class Bank: LoginObserver {
    func loginSuccess() {
        //Do required after login success stuff
    }
}





/* NotificationCenter - Observed Design Pattern for one to many communication
 Delegate - for 1- 1 communication, very simple Observed Design Pattern
 NotificationCenter delivers the notification on the same thread where post was called
 
 CASE 1: Posting on main thread
 postObserver() // called from main → func myNotificationReceived runs on main thread
 
 CASE 2: Posting on background thread
 DispatchQueue.global().async {
 self.postObserver()
 } //called from BG → myNotificationReceived runs on that background thread
 
 
 CASE 3: Adding on Main
 NotificationCenter.default.addObserver(
 forName: customNotificationName,
 object: nil,
 queue: .main
 ) { notification in
 // guaranteed on main thread even if post on BG thread
 }
 
 
 How to send Data- We have two ways to attach data when posting a notification:
 Using object - for single object like string or model
 Using userInfo - for dictionary
 */

extension ViewController {
    //This will be inside observers class
    func addObserver() {
        //Custom Notification
        NotificationCenter.default.addObserver(self, selector: #selector(myNotificationReceived(_:)), name: customNotificationName, object: nil)
        //System Notification - iOS posts them automatically when certain system events happen. We just addObserver, and we will receive them.
        NotificationCenter.default.addObserver(self, selector: #selector(myNotificationReceived(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self) //All observers from self will remove
        NotificationCenter.default.removeObserver(self, name: customNotificationName, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //This will be inside class which will be observed by observers
    func postObserver() {
        NotificationCenter.default.post(name: customNotificationName, object: "MyDataString")
        //["id": 42, "name": "Amber"]
        //NotificationCenter.default.post(name: customNotificationName, object: nil, userInfo: ["id": 42, "name": "Amber"])
    }
    
    @objc func myNotificationReceived(_ notification: Notification) {
        //DO work after receiving notification like UI update
        //NotificationCenter delivers the notification on the same thread where post was called
        //Switch on main thread if posting on background thread
        if let text = notification.object as? String {
            print("Received text:", text)
        }
        
        //        if let info = notification.userInfo,
        //           let id = info["id"] as? Int,
        //           let name = info["name"] as? String {
        //            print("Received id:", id, "name:", name)
        //        }
    }
}


//Sender A posts
//NotificationCenter.default.post(name: customNotificationName, object: senderA)
//
//Sender B posts
//NotificationCenter.default.post(name: customNotificationName, object: senderB)
//
//Observer 1: only cares about senderA, it will receive notification only if sender is senderA
//NotificationCenter.default.addObserver(self, selector: #selector(handle), name: customNotificationName, object: senderA)
//
//Observer 2: listens to all senders
//NotificationCenter.default.addObserver(self, selector: #selector(handle), name: customNotificationName, object: nil)







//KVO - Observed Design Pattern, for observing any changes in the property
class Person: NSObject {
    //Need to inherit from NSObject
    //Need @objc and dynamic to make property as observable property
    @objc dynamic var name: String?
}

extension ViewController {
    func personKVO_name() {
        let person = Person()
        //Even though we are not using observing, but we need to assign in let observing to execute completion handler. Otherwise it will not observe and will not execute handler
        let observing = person.observe(\.name, options: [.new]) { obj, value in
            print("observing \(obj) class changes in name property, newValue \(value)")
        }
        person.name = "Amber"
    }
}





/* Combine - Observed Design Pattern, @published + Sink (Subscriber handler)
 This is clean Observer Pattern
 */
class User {
    @Published var name: String? //Publisher
}

extension ViewController {
    func combineToRunHandler() {
        let user = User()
        
        //Both sink and receive are operators that attach a Subscriber to a Publisher.
        _ = user.$name.sink { value in //sink is Subscriber
            print("subscriber received changes in name property, newValue \(value ?? "")")
        }
        
        user.name = "Safia"
    }
    
    /*@Published emits values on the thread where the property is set.
     If user.name = "Amber" is set on the main thread, the sink runs on the main thread.
     If it’s set from a background thread, sink runs on that background thread.*/
    func combineToRunHandlerOnMainThread() {
        let user = User()
        
        //Both sink and receive are operators that attach a Subscriber to a Publisher.
        _ = user.$name
            .receive(on: DispatchQueue.main)
            .sink { value in //sink is Subscriber and it will execute on main thread
                print("subscriber received changes in name property, newValue \(value ?? "")")
            }
        
        user.name = "Safia" //handler will call when value change as it is published property
    }
}



class ArrayPublisher {
    //Array has publisher, it will send array values one by one and handler will call for all values one by one
    let arrayPublisherProperty = ["A", "B", "C"].publisher
    
    func arrayPublisherSubscriber() {
        let _ = arrayPublisherProperty.sink { value in
            print("Received value:", value)
        }
    }
}

extension ViewController {
    //    var _ = URLSession.shared.dataTaskPublisher(for: "ActualURLLink")
    //        .sink { _ in
    //            print("Thread in sink: \(Thread.current)") //dataTaskPublisher always send on BG thread so we need to manually swich on main thread before UI Update.
    //        }
}
