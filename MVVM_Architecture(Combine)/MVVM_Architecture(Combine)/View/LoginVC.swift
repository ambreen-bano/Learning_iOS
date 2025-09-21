//
//  ViewController.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 23/08/25.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        if let homeVC = UIStoryboard(name: "HomeVC", bundle: .main).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
}
