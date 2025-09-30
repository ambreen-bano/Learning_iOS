//
//  FirstVC.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 23/01/23.
//

import UIKit


class FirstVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        //No Need to create Instance of the Class, we will use shared instance of the class
        //This data we can use in another VC (globally in the project) using this shared instance
        APICaller.shared.callAPIAndUpdateDate()
        APICaller.shared.response = "Updated reponse in First VC"
        APICaller.shared.anyOther = "Other Data"
        
        //Above we have modified Data and now we are reading
        if let response = APICaller.shared.response {
            print("\nData From First VC = " + response)
        }
        if let other = APICaller.shared.anyOther {
            print(other)
        }
        
        self.navigationController?.pushViewController(PropertyObserverVC(), animated: true)
        
        //self.navigationController?.pushViewController(SecondVC(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let response = APICaller.shared.response {
            print("\nData From First VC from ViewWillAppear = " + response)
        }
    }
}





/*__________________________Singleton Class______________________________________*/

final class APICaller {
    //This is API service Singleton Class, only one static shared instance of the class is created, init is private so no one can create instance from outside.
    //Static/Global Object of the class, which can be use anywhere in the project
    //life cycle of this shared object will be available untill app killed - checked
    //final class so no one can inherit this class, so only having single instance
    //But singleton class is hard to test, we can't mock. And data race condition can also occure for mutable properties of the class as it provides global access
    static let shared = APICaller() //Global instance of the class
    
    private init() {} //Private init for singleton class (eg. userDefault or URLSession class )
    
    var url: String?
    var response: String?
    var anyOther: String?
    
    func callAPIAndUpdateDate(){
        //Assume call Some API and we have response data
    }
}

/*________________________________________________________________*/
