//
//  AppCoordinator.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 27/08/25.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}


class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if let loginVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "Main") as? LoginVC {
            loginVC.onLoginSuccess = { [weak self] in
                self?.pushHomeVC()
            }
            self.navigationController.pushViewController(loginVC, animated: true)
        }
    }
    
    func pushHomeVC() {
        if let homeVC = UIStoryboard(name: "HomeVC", bundle: .main).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
            homeVC.onProfileBtnTapped = { [weak self] in
                self?.pushProfileVC()
            }
            self.navigationController.pushViewController(homeVC, animated: true)
        }
    }
    
    func pushProfileVC() {
        if let profileVC = UIStoryboard(name: "ProfileVC", bundle: .main).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
            navigationController.popToRootViewController(animated: true)
            navigationController.pushViewController(profileVC, animated: true)
        } else {
            print("Some Error Occurred in Displaying Profile")
        }
    }
}
