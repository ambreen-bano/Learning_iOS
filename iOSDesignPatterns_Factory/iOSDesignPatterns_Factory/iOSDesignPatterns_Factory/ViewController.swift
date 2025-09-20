//
//  ViewController.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 23/08/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let createPayment1 = CreatePaymentFactory.proceedToPayWith(type: .bank)
        createPayment1.pay() //It doesn't know about the BankPayment Classes [Encapsulation]
        
        let createPayment2 = CreatePaymentFactory.proceedToPayWith(type: .upi)
        createPayment2.pay() //It doesn't know about the UPIPayment Classes [Encapsulation]
    }
}


/* Design Pattern - Factory Pattern
 A creational pattern that provides an interface to create objects without exposing their concrete classes.
 Factory pattern centeralize the differnet type of object creation logic [ creation logic is not scattered]. And it provide encapsulation of the object creation logic.
 Below is Example with Payment with Factory Pattern-
 CreatePayment class create different objects(UPI and Bank Objects) without exposing the creation logic of specific object
 
 when to use - when object creation logic is COMPLEX, and we want modular decouple and scalable project.
 eg. we can hide creation of differnet types of SHAPE - circle, square, rectangle for drawing function etc.
 
 iOS SDK Example -  UITableViewCell.dequeueReusableCell(withIdentifier:) - factory decides which cell object instance to return.
 
 Abstract Factory - Factory class  that produces other factories object instance.
 Useful when you have families of related objects.
 Example: ButtonFactory can create iOSButton or AndroidButton.
 */

protocol Payment {
    //UPI or bank both are related families of payment
    func pay()
}

class UPIPayment: Payment {
    func pay() {  }
}

class BankPayment: Payment {
    func pay() { }
}


enum PaymentType { //What is supported in Factory
    case upi
    case bank
}

class CreatePaymentFactory {
    static func proceedToPayWith(type: PaymentType) -> Payment {
        switch type {
        case .upi:
            UPIPayment()
        case .bank:
            BankPayment()
        }
    }
}


