//
//  ViewController.swift
//  iOSDesignPatterns_Router
//
//  Created by user2 on 20/09/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


/*Design Pattern - Router Pattern Basic
 Router doesn’t know the flow — it just executes push/present when asked.
 Only Handles single navigation actions like push/present/dismiss. Doesn't know the flow. like what is next screen after this action.
 
 Router instance created by VC (Entry point for Router), Router is Module Specific navigation
 App Coordinator instance created by AppDelegate (Entry point for App Coordinator)  App Coordinator is App Specific navigation
 */


class Router {
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToHome() {
        let homeVC = HomeVC()
        navigationController?.pushViewController(homeVC, animated: true)
    }
}

class LoginMainVC : UIViewController {
    
    var router: Router? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Router Instance is created by VC
        router = Router(navigationController: self.navigationController ?? UINavigationController())
    }
    
    func loginSuccess(){
        router?.navigateToHome()
    }

}
