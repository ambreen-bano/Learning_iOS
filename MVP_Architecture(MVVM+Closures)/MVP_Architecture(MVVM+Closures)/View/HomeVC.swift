//
//  HomeVC.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 26/08/25.
//

import Foundation
import UIKit

/*
 MVVM -
 Model (M)
 1.Contain data
 2.business logic(Network only).
 
 View (V)
 1. Displaying UI
 2. Capturing user interactions and forwarding it to controller
 
 Controller (C)
 1. Glue between View and ViewModel(controller act like coordinator between view and viewModel).
 2. Receive user interactions (from View - tableview, button taps, text input) and forwarding to VM.
 3. Observes outputs from VM and updates UI.
 
 ViewModel (VM)
 1. Middle layer between View and Model.
 2. Receive input from controller, process it and send output back to controller
 */
 

/*
 Business Logic Examples -
 1. Data Transformation/Formatting (Model → UI-Ready Format)
 2. Input Validation
 3. API Calls
 4. Business Rules for Display some View
 5. Business rules conditions/calculations(eg.canPurchase, isEligibleForDiscount).
 
 Business logic is the rules that govern how your app behaves, like validating a password, calculating discounts, or deciding what to show based on user role.

 API calling itself is more like data fetching or data access, not the actual rules of your app. It’s about how you get data, not what to do with it.
*/
 

/*
 About Project -----
 M - Model - UserModel, Network
 V - View - HomeTableViewCell, LoginVC, HomeVC, ProfileVC
 VM - ViewModel - HomeTableCellViewModel(For converting UI Friendly cell model), HomeViewModel
 
 ├─ Model
 │  ├─ UserModel.swift
 │  └─ Network.swift
 ├─ ViewModel
 │  ├─ HomeTableCellViewModel.swift
 │  └─ HomeViewModel.swift
 ├─ View
 │  └─ HomeTableViewCell.swift
 └─ Controller
    └─ LoginVC.swift, HomeVC.swift, ProfileVC.swift
 
 
 
 We have LoginVC -> HomeVC -> ProfileVC
 LoginVC is Root VC
 LoginVC on login success -> pushes HomeVC
 
 HomeVC contain Profile Button (Profile Entry Point)
 HomeVC contain Tableview
 HomeVC create ViewModel (HomeViewModel.Swift)
 HomeVC Initialize ViewModel
 HomeVC Binds ViewModel (HomeVC implements closures of the ViewModel)
 HomeVC Setup ViewModel
 HomeVC Calls ViewModel for UI friendly HomeTableCellViewModel to display on UI
 HomeVC Call ViewModel on any callbacks from view/subviews like tablecell Btn Tapped event
 HomeVC handles navigation logic. When Profile buttin click HomeVC pushes ProfileVC
 
 HomeViewModel define closure for all events and call them when event occured
 HomeViewModel call Network for API Call
 HomeViewModel Convert Data Model UserModel into UI friendly HomeTableCellViewModel(data display on UI)
 
 TableViewCell contains label and Button
 TableViewCell notify VC about Button click using closure
 
 1. VC calls ViewModel functions for all business logic and set/obseve closures of the ViewModel for callbacks
 2. ViewModel do all the business logic and call closures to give callback to VC.
 */


/*
 What VC handles in MVVM - (Still Massive View Controller issue because of navigation logic handling)
 1. VC Create ViewModel
 2. VC Bind ViewModel - VC set ViewModel closures
 3. VC Register or create UI View Objects
 4. Binding UI Friendly model into UI to display on screen
 5. Navigation
*/


class HomeVC: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    //1. Create ViewModel Object
    var homeViewModel: HomeViewModel = HomeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: .main), forCellReuseIdentifier: "HomeTableViewCell")
        passwordTextField.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        
        // 2. Binding with ViewModel
        bindsViewModel()
        // 3. Initialize or setup ViewModel
        homeViewModel.viewDidLoad()
    }
    
    @IBAction func profileBtnTapped(_ sender: Any) {
        // VC handles
        // Navigation
        if let profileVC = UIStoryboard(name: "ProfileVC", bundle: .main).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.pushViewController(profileVC, animated: true)
        } else {
            print("Some Error Occurred in Displaying Profile")
        }
    }
}

extension HomeVC {
    @objc func textFieldEditing() {
        // Call ViewModel Function for validation on receiving view interactions
        homeViewModel.didEnterPasswordToValidate(password: passwordTextField.text ?? "")
    }
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 4. Call ViewModel for number of items
        return homeViewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell {
            let model = homeViewModel.homeCellViewModel(index: indexPath)
            // VC handles
            // 5. Call ViewModel for UI friendly model to display on the screen
            cell.label.text = model.labelText
            cell.button.setTitle(model.buttonTitle, for: .normal)
            cell.onBtnTapped = { [weak self] in
                // 6. Call ViewModel Function on any View/Subview CallBacks(VC will listen ONLY VM callbacks)
                self?.homeViewModel.cellBtnTapped()
            }
            return cell
        }
        return UITableViewCell()
    }
}


extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //7. Call ViewModel Function on receiving view interactions
        homeViewModel.didSelectRow()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeVC {
    // Binding with ViewModel
    
    func bindsViewModel() {
        // VC listens closures of the ViewModel
        homeViewModel.reloadData = { [weak self] in
            self?.homeTableView.reloadData()
        }
        
        homeViewModel.onSelectRow = {
            print("TableView Cell Selected")
        }
        
        homeViewModel.onCellBtnTapped = {
            print("TableViewCell Button Tapped")
        }
        
        homeViewModel.onPasswordValidation = { [weak self] (isValid) in
            if isValid {
                self?.passwordLabel.text = "Good To Go!"
            } else {
                self?.passwordLabel.text = "Enter another password"
            }
        }
    }
}

