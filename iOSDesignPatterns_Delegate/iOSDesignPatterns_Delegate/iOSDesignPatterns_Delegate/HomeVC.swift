//
//  ViewController.swift
//  iOSDesignPatterns_Delegate
//
//  Created by Ambreen Bano on 25/08/25.
//

import UIKit

/*Design Pattern - Delegate Pattern
 A way for one object to communicate back to another, typically implemented using a protocol.
 This is implemented using Protocols.
 Always use WEAK for delegate to avoid retain cycle (for using weak, protocol should inherit from NSObject)
 it is a pattern of sending information from child back to parent class.
 It is tightly couples as both classes are dependent on same delegate for communication
 But provide Reusable component with delegates, who ever set it can call own operation to do on delegate methods
 Example : UITableViewDelegate, UITextFieldDelegate
 */

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let childVC = UIStoryboard(name: "MyCustomButtonVC", bundle: .main).instantiateViewController(withIdentifier: "MyCustomButtonVC") as? MyCustomButtonVC {
            childVC.delegate = self
            present(childVC, animated: true)
        }
    }
}

extension HomeVC: buttonClicked {
    func clickAction() {
        print("Button Clicked!")
    }
}
