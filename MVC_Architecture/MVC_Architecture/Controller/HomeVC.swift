//
//  HomeVC.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 26/08/25.
//

import Foundation
import UIKit

/*
 About Project -----
 
 Model (M)
 1.Contain data
 2.business logic(Network only).
 
 View (V)
 1. Displaying UI
 2. Capturing user interactions and forwarding it to controller
 
 Controller (C)
 Receive user interactions (from View - tableview, button taps, text input)
 Process it, all business logic is done by controller only (Data formatting, validation, business rules to show some view)
 Bind updated data with view
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
 MVC -
 M - Model - UserModel
 V - View - UITableViewCell - HomeTableViewCell
 C - Controller - LoginVC, HomeVC, ProfileVC
 
 
 ├─ Model
 │  ├─ UserModel.swift
 │  └─ Network.swift (WE can move API call from controller to Model)
 ├─ View
 │  └─ HomeTableViewCell.swift
 └─ Controller
    └─ LoginVC.swift, HomeVC.swift, ProfileVC.swift
 
 
 
 We have LoginVC -> HomeVC -> ProfileVC
 LoginVC is Root VC
 LoginVC on login success -> pushes HomeVC
 
 HomeVC contain Profile Button (Profile Entry Point)
 HomeVC contain Tableview
 HomeVC create Data Model [UserModel] array of Model UserModel.
 HomeVC Call API and update Data Model (API Call we can move in Model Folder as it is business logic and generally API/Network layer is belongs to model)
 HomeVC Convert Data Model UserModel into UI friendly Model(data display on UI)
 HomeVC bind UI friendly model with View (UI display on screen)
 HomeVC handles View interaction events(table cell click/ table cell btn click delegate)
 HomeVC handles navigation logic. When Profile buttin click HomeVC pushes ProfileVC
 
 TableViewCell contains label and Button
 TableViewCell notify VC about Button click using delegate protocol
 */


/*
 What VC handles in MVC - (Massive View Controller issue because of lot of handling is done by VC)
 1. VC Create Data Model
 2. VC Register or create UI View Objects
 3. API Calling
 4. Parsing and updating Data Model
 5. Convert Data model to UI Friendly model
 6. Binding model into UI to display on screen
 7. Delegate Callbacks
 8. Navigation
*/


class HomeVC: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    
    //1. VC Create Data Model
    var userModel: [UserModel] = [UserModel(id: 1, name: "Amber")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //2. VC Register or create UI View Objects
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: .main), forCellReuseIdentifier: "HomeTableViewCell")
        fetchModel()
    }
    
    @IBAction func profileBtnTapped(_ sender: Any) {
        //VC handles
        //8. Navigation
        if let profileVC = UIStoryboard(name: "ProfileVC", bundle: .main).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.pushViewController(profileVC, animated: true)
        } else {
            print("Some Error Occurred in Displaying Profile")
        }
        
    }
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell {
            let model = userModel[indexPath.item]
            //VC handles
            //5. Convert Data model to UI Friendly model
            //6. Binding model into UI to display on screen
            cell.label.text = "\(model.id) - " + model.name
            cell.button.setTitle("ID : \(model.id)", for: .normal)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}


extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TableView Cell is Clicked")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeVC {
    //VC handles
    //3. API Calling
    //4. Parsing and updating Data Model
    func fetchModel() {
        //API call to fetch data
        userModel.append(UserModel(id: 2, name: "Safia"))
        userModel.append(UserModel(id: 3, name: "Iram"))
        userModel.append(UserModel(id: 4, name: "Saba"))
    }
}


extension HomeVC: notifyParentAboutBtnTapped {
    //VC handles
    //7. Delegate Callbacks
    func didTapButton() {
        print("TableView Cell is Button Clicked")
        
    }
}
