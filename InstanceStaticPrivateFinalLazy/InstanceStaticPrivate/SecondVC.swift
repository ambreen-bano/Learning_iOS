//
//  SecondVC.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 23/01/23.
//

import UIKit


class SecondVC: UIViewController {
    var name: String?
    //No Non-Optional stored properties, so init is not required in class to define.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        
        //We are reading data from static shared instance
        //This is very helpful as server data fetched, stored in shared instance and can be use in any VC using Static shared instance of singleton class
        if let response = APICaller.shared.response {
            print("\nData From Second VC = " + response)
        }
        if let other = APICaller.shared.anyOther {
            print(other)
        }
        
        //We can modify data and can pop but still we can use shared instance updated data in previous VC
        APICaller.shared.response = "Updated reponse in Second VC"
        self.navigationController?.popViewController(animated: true)
    }
}
