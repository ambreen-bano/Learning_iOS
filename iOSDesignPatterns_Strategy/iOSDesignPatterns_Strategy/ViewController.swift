//
//  ViewController.swift
//  iOSDesignPatterns_Strategy
//
//  Created by user2 on 20/09/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callStrategy()
    }
}


/* Design Pattern - Strategy Pattern
 Defines a family of algorithms/behaviors and makes them interchangeable at runtime.
 Avoids hardcoding multiple if-else or switch statements.
 We can add new strategy methods without modifying existing code → Open/Closed Principle.
 How to make Strategy dynamic in iOS UI?
 Example: User selects a sorting/filtering option in settings → context updates strategy dynamically and fetched new results on the basis filter selected on UI.
 */


protocol TaskStrategy {
    func performTask()
}

class strategy1: TaskStrategy {
    func performTask() {
        print("Task done using strategy 1")
    }
}

class strategy2 : TaskStrategy{
    func performTask() {
        print("Task done using strategy 2")
    }
}

class Strategy {
    
    var taskStrategy: TaskStrategy
    
    init(taskStrategy: TaskStrategy) {
        self.taskStrategy = taskStrategy
    }
    
    func setTaskStrategy(taskStrategy: TaskStrategy) {
        self.taskStrategy = taskStrategy
    }
    
    func perform() {
        taskStrategy.performTask()
    }
}


func callStrategy() {
    let strategyManager = Strategy(taskStrategy: strategy1())
    strategyManager.perform()
    strategyManager.setTaskStrategy(taskStrategy: strategy2())
    strategyManager.perform()
}
