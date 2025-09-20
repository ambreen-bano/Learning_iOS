//
//  MyCustomButtonVC.swift
//  iOSDesignPatterns_Delegate
//
//  Created by Ambreen Bano on 25/08/25.
//

import Foundation
import UIKit

protocol buttonClicked: AnyObject { //should be inherit from AnyObject if want to make it weak
    //using AnyObject, it becomes reference type protocol
    //Without AnyObject, it is value type protocol
    func clickAction()
}

class MyCustomButtonVC: UIViewController { //Child Class
    weak var delegate: buttonClicked?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didTap() //We can call this when action button clicked
    }
    
    func didTap() {
        delegate?.clickAction()
    }
}
