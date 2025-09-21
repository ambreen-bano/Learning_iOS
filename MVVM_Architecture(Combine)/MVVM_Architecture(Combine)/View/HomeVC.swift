//
//  HomeVC.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 26/08/25.
//

import Foundation
import UIKit
import Combine

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
 Pure MVVM = MVVM + Combine
 
 In Pure MVVM with Combine, the ViewModel exposes Publishers for all UI state and events.
 The View subscribes to these publishers and updates the UI automatically. User interactions are fed into the ViewModel via Subjects, keeping the ViewController as a thin binder.
 The Model handles business logic/data, View displays UI, and VM orchestrates everything reactively.
 
*/


class HomeVC: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    //Create ViewModel Object
    var homeViewModel: HomeViewModel = HomeViewModel()
    var cancellable = Set<AnyCancellable>()
    
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
        homeViewModel.didEnterPasswordToValidate.send(passwordTextField.text ?? "")
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
            cell.$onBtnTapped.sink(receiveValue: { [weak self] (isClicked) in
                if isClicked {
                    // 5. Send manual publisher to ViewModel on any View/Subview interaction event receive
                    self?.homeViewModel.cellBtnTapped.send()
                }
            })
            .store(in: &cancellable)
            return cell
        }
        return UITableViewCell()
    }
}


extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //6. Call ViewModel Function on receiving view interactions
        homeViewModel.didSelectRow.send() //manual publisher value send
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeVC {
    // Binding with ViewModel
    
    func bindsViewModel() {
        // VC subscribe to VM publishers for listening changes
        
        homeViewModel.$userModel
            .receive(on: DispatchQueue.main) //always receive subscriber on main thread even if sender send on BG thread
            .sink {[weak self] _ in
            self?.homeTableView.reloadData()
        }.store(in: &cancellable)
        
        
        homeViewModel.$isPasswordValid
            .receive(on: RunLoop.main) //always receive subscriber on main thread even if sender send on BG thread
            .sink { [weak self] isValid in
            if isValid {
                self?.passwordLabel.text = "Good To Go!"
            } else {
                self?.passwordLabel.text = "Enter another password"
            }
        }.store(in: &cancellable)
        
        
        homeViewModel.$onRowSelectMsg.sink { msg in
            print(msg)
        }.store(in: &cancellable)
        
        
        homeViewModel.$onButtonTappedMsg.sink { msg in
            print(msg)
        }.store(in: &cancellable)
    }
}



