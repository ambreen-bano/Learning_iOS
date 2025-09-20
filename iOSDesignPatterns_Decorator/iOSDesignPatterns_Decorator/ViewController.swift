//
//  ViewController.swift
//  iOSDesignPatterns_Decorator
//
//  Created by user2 on 20/09/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callDecorator()
    }
}



/* Design Pattern - Decorator Pattern
 
 Add additional responsibilities or behaviors to an object dynamically, without changing its class.
 Each decorator takes object, decorate it (add some functionality) and return it.
 Original class (SimpleCoffee) remains unchanged.
 Inject base class into decorators to wrap it with decoration and then return it
 
 */

protocol Coffee { //Protocol
    func cost() -> Double
    func ingridient() -> String
}

class SimpleCoffee: Coffee { //Base class/product
    func cost() -> Double {
        return 10
    }
    
    func ingridient() -> String {
        return "Plain Coffee"
    }
}

class MilkDecorator : Coffee { //Adopt Base class protocol /product to decorate
    let coffee: Coffee //Inject Base class protocol/product to decorate
    
    init(coffee: Coffee) {
        self.coffee = coffee
    }
    
    func cost() -> Double {
        self.coffee.cost() + 5.0
    }
    
    func ingridient() -> String {
        self.coffee.ingridient() + " " + "Milk"
    }
}

class SugarDecorator : Coffee {
    let coffee: Coffee //Inject Base class to decorate
    
    init(coffee: Coffee) {
        self.coffee = coffee
    }
    
    func cost() -> Double {
        self.coffee.cost() + 2.0
    }
    
    func ingridient() -> String {
        self.coffee.ingridient() + " " + "Sugar"
    }
}


func callDecorator() {
    var coffee: Coffee = SimpleCoffee()
    coffee = MilkDecorator(coffee: coffee) //Add Milk
    coffee = SugarDecorator(coffee: coffee) //Add Sugar
    let finalCost = coffee.cost()
    let allIngridients = coffee.ingridient()
    print(finalCost) //Check if it is printing correct or else we need to call coffee.cost() with decorators
    print(allIngridients)
}
