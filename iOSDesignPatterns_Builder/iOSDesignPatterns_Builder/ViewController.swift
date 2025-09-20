//
//  ViewController.swift
//  iOSDesignPatterns_Builder
//
//  Created by Ambreen Bano on 23/08/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pizza = PizzaBuilder()
            .addCheese(cheese: "MyCheese")
            .addTopping(topping: "MyTopping")
            .addType(isPanType: true)
            .build()
        
        //Sometimes we wrap above code inside BuilderDirector class to make it more simple
        //Director encapsulate the construction logic from the client/outside code.
        let onionPizza = PizzaDirector().makeNonPanOnionPizza()
    }
}

/* Design Pattern -Builder Pattern creates object step by step rather than creating in one step (like Factory Pattern).
 Builder Pattern is a creational design pattern for complex objects.
 Focuses on step-by-step object creation instead of passing a giant constructor with many parameters.
 vs Factory Pattern - Pass all params in one shot to create object.
 provide Fluent interface - method chaining
 when to use - When object creation is complex and Big
 
 pizzaClass -> pizzaBuilderClass(step by step create object) -> PizzaBuilderDirector (encapsulate creation logic)
 */

struct Pizza {
    //How to build immutable objects - make these properties as "let"
    var cheese: String?
    var topping: String?
    var isPanType: Bool?
}

class PizzaBuilder {
    private var cheese: String?
    private var topping: String?
    private var isPanType: Bool?
    
    func addCheese(cheese: String) -> PizzaBuilder {
        self.cheese = cheese
        return self //return self for method chaining for step by step creation
    }
    
    func addTopping(topping: String) -> PizzaBuilder{
        self.topping = topping
        return self
    }
    
    func addType(isPanType: Bool) -> PizzaBuilder {
        self.isPanType = isPanType
        return self
    }
    
    func build() -> Pizza {
        return Pizza(cheese: cheese, topping: topping, isPanType: isPanType)
    }
}



/* Using Wrapper (Director Class) on above builder class - Optional*/

class PizzaDirector {
    
    private let pizzaBuilder = PizzaBuilder()
    
    func makePanTomatoPizza() -> Pizza {
        let pizza = pizzaBuilder
            .addCheese(cheese: "MyCheese")
            .addTopping(topping: "Tomato")
            .addType(isPanType: true)
            .build()
        return pizza
    }
    
    func makeNonPanOnionPizza() -> Pizza {
        let pizza = pizzaBuilder
            .addCheese(cheese: "MyCheese")
            .addTopping(topping: "Onion")
            .addType(isPanType: false)
            .build()
        return pizza
    }
}
