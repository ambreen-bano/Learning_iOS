//
//  ViewController.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 23/08/25.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    
    var onLoginSuccess : (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        // VC handles navigation via Coordinator (moved navigation logic from VC to AppCoordinator)
        onLoginSuccess?()
    }

}
