//
//  ViewController.swift
//  iOSDesignPatterns_Coordinator
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



/*Design Pattern - Coordinator Pattern using Protocols/Delegates
 A Coordinator is pattern that handles navigation flow in an app.
 Separates navigation logic from view controllers to App Coordinator. (Resolve Massive VC issue)
 Instead of letting UIViewControllers decide what comes next, the Coordinator is responsible for creating, presenting, and dismissing view controllers.
 
 We can have multiple coordinators-
 AppCoordinator (root)
 AuthCoordinator (login flow)
 ProfileCoordinator (profile section)
 Each manages its own navigation stack.
 
 Router instance created by VC (Entry point for Router), Router is Module Specific navigation
 App Coordinator instance created by AppDelegate (Entry point for App Coordinator)  App Coordinator is App Specific navigation
 */


protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    let dependencyInject1: APIService //Inject Any other required dependency(use in VC's because App Coordinator creates VC here only) from Outside instead of hardcoding
    
    init(navigationController: UINavigationController, dependencyInject1: APIService) {
        self.navigationController = navigationController
        self.dependencyInject1 = dependencyInject1 //Inject dependency from Outside instead of hardcoding
    }
    
    func start() {
        screen1()
    }
    
    func screen1() {
        let loginVC = LoginVC()
        loginVC.apiService = dependencyInject1 //Inject Dependency
        loginVC.delegate = self
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func screen2() {
        let homeVC = HomeVC()
        homeVC.delegate = self
        navigationController.pushViewController(homeVC, animated: true)
    }
}

extension AppCoordinator: Login {
    func loginSuccess() { //Screen1 Delegate callbcak
        screen2()
    }
}

extension AppCoordinator: Logout {
    func logoutSuccess() { //Screen2 Delegate callbcak
        screen1()
    }
}



/* Login Screen handling */
protocol APIService: AnyObject { //Protocol required to inject in VC
    func CallAPI()
}

class Network: APIService {
    func CallAPI() {
        //Call API and deal with network
    }
}

protocol Login: AnyObject {
    func loginSuccess()
}

class LoginVC: UIViewController {
    
    weak var delegate: Login?
    var apiService : APIService? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        loginDone(isSuccess: true)
    }
    
    func loginDone(isSuccess: Bool) {
        apiService?.CallAPI()
        if isSuccess {
            delegate?.loginSuccess()
        }
    }

}

/* Home Screen handling */
protocol Logout: AnyObject {
    func logoutSuccess()
}

class HomeVC: UIViewController {
    
    weak var delegate: Logout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func logoutDone(isSuccess: Bool) {
        if isSuccess {
            delegate?.logoutSuccess()
        }
    }
}









/* Design Pattern - Coordinator Pattern using Closures */

protocol Coordinator1 {
    var navigationController: UINavigationController { get }
    func start()
}

class AppCoordinator1: Coordinator1 {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        screen1()
    }
    
    func screen1() {
        let loginVC = LoginVC1()
        loginVC.onLoginDone { isSuccess in
            if isSuccess {
                screen2()
            }
        }
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func screen2() {
        let homeVC = HomeVC1()
        homeVC.onLogoutDone { isLogout in
            if isLogout {
                screen1()
            }
        }
        navigationController.pushViewController(homeVC, animated: true)
    }
}


class LoginVC1: UIViewController {
    var isSuccess = false
    override func viewDidLoad() {
        super.viewDidLoad()
        isSuccess = true
    }
    
    func onLoginDone(handler: (Bool)-> Void) {
        handler(isSuccess)
    }
}


class HomeVC1: UIViewController {
    var isLogout = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onLogoutDone(handler: (Bool)-> Void) {
        handler(isLogout)
    }
}







/* Design Pattern - Coordinator Pattern - with Multiple Coordinators for App flows
 one Root App Coordinator (App Coordinator) [Contain Child coordinators array]
 sub module1 Coordinator (Auth Coordinator) [Contain property parent to hold instance of Root App Coordinator]
 sub module1 Coordinator (Travel Coordinator)
 */

class AppCoordinatorRoot: Coordinator { //This is Root App ccordinator
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        loginCoordinator()
    }
    
    func loginCoordinator() {
        let loginCoordinator = AppLoginCoordinator(navigationController: navigationController)
        loginCoordinator.parent = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    func bankCoordinator() {
        let bankCoordinator = AppBankCoordinator(navigationController: navigationController)
        bankCoordinator.parent = self
        childCoordinators.append(bankCoordinator)
        bankCoordinator.start()
    }
    
    func removeChildCoordinator(child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}


class AppLoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parent : AppCoordinatorRoot?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginVC1()
        loginVC.onLoginDone { [weak self] isSuccess in
            guard let self = self else {return}
            if isSuccess {
                parent?.removeChildCoordinator(child: self)
                parent?.bankCoordinator()
            }
        }
        navigationController.pushViewController(loginVC, animated: true)
    }
}


class AppBankCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parent : AppCoordinatorRoot?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        //Same as Other coordinators
    }
}
