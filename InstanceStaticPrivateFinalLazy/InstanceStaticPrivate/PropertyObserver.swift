//
//  PropertyObserver.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 19/02/23.
//

import UIKit

//Property observes are only for stored properties (computed properties can not have observers)
class PropertyObserverVC: UIViewController {
    
    // In property observer Mandatory to have initial value as shown below "0"
    var accountBalance: Int = 0 {
        //only for observation, don't write any other code calculations or assignments
        //Never assign value inside observers otherwise recurssion deadlock can happen, as when we assign again the that statement trigger observer again
        
        //willSet will call before setting it's value to the accountBalance
        willSet{
            print("Will Set called newValue = \(newValue)")
            print("Will Set called = \(accountBalance)")
        }
        //didSet will call after setting it's value to the accountBalance
        didSet{
            print("did Set called oldValue = \(oldValue)")
            print("did Set Called = \(accountBalance)")
            //accountBalance = 100 //Don't otherwise it will create deadlock cycle
        }
    }
    
    var accountBalanceWillNameChange: Int = 0 {
        willSet(newValueB){
            print("Will Set called newValueB = \(newValueB)")
        }
        didSet(oldValueB){
            print("did Set called oldValue = \(oldValueB)")
            print("did Set Called = \(accountBalanceWillNameChange)")
        }
    }
    
    //Initial value is not required here with  = {}()
    var storedProperty: UILabel = {
       let label = UILabel()
        label.text = "Hello, World!"
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountBalance = 100
        accountBalanceWillNameChange = 200
    }
}
