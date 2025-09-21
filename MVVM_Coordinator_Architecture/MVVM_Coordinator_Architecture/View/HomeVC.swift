//
//  HomeVC.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 26/08/25.
//

import Foundation
import UIKit

/*
 
 MVVM + Coordinator -
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
 
 Coordinator
 1. Handles All App Flow Navigation Logic
 
 */

/*
 About Project -----
 M - Model - UserModel, Network
 V - View - HomeTableViewCell, LoginVC, HomeVC, ProfileVC
 VM - ViewModel - HomeTableCellViewModel(For converting UI Friendly cell model), HomeViewModel
 Coordinator - AppCoordinator
 
 
 ├─ Model
 │  ├─ UserModel.swift
 │  └─ Network.swift
 ├─ ViewModel
 │  ├─ HomeTableCellViewModel.swift
 │  └─ HomeViewModel.swift
 ├─ View
 │  └─ HomeTableViewCell.swift
 └─ Controller
 │   └─ LoginVC.swift, HomeVC.swift, ProfileVC.swift
 └─ Coordinator
    └─ AppCoordinator.swift
 
 Business logic is the rules that govern how your app behaves, like validating a password, calculating discounts, or deciding what to show based on user role.

 API calling itself is more like data fetching or data access, not the actual rules of your app. It’s about how you get data, not what to do with it.

 */


class HomeVC: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    //Create ViewModel Object
    var homeViewModel: HomeViewModel = HomeViewModel()
    var onProfileBtnTapped: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: .main), forCellReuseIdentifier: "HomeTableViewCell")
        passwordTextField.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        
        // 1. Binding with ViewModel
        bindsViewModel()
        // 2. Initialize or setup ViewModel
        homeViewModel.viewDidLoad()
    }
    
    @IBAction func profileBtnTapped(_ sender: Any) {
        // VC handles navigation via Coordinator (moved navigation logic from VC to AppCoordinator)
        onProfileBtnTapped?()
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
        // 3. Call ViewModel for number of items
        return homeViewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell {
            let model = homeViewModel.homeCellViewModel(index: indexPath)
            // VC handles
            // 4. Call ViewModel for UI friendly model to display on the screen
            cell.label.text = model.labelText
            cell.button.setTitle(model.buttonTitle, for: .normal)
            cell.onBtnTapped = { [weak self] in
                // 5. Call ViewModel Function on any View/Subview CallBacks(VC will listen ONLY VM callbacks)
                self?.homeViewModel.cellBtnTapped()
            }
            return cell
        }
        return UITableViewCell()
    }
}


extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //6. Call ViewModel Function on receiving view interactions
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
        
        homeViewModel.onPasswordValidation = { [weak self] isValid in
            if isValid {
                self?.passwordLabel.text = "Good To Go!"
            } else {
                self?.passwordLabel.text = "Enter another password"
            }
        }
    }
}

