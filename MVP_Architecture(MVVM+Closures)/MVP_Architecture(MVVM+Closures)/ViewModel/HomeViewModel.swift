//
//  HomeViewModel.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 26/08/25.
//

import Foundation

//This is for HomeVC
//ViewModel Handles formattinmgs, validations, API Calls
class HomeViewModel {
    
    var userModel: [UserModel] = []
    let networkService: NetworkAPIService
    
    //ViewModel will DEFINE and CALL closures (VC listen closure callback and perform work)
    var onPasswordValidation: ((Bool)-> Void)?
    var onSelectRow: (()-> Void)?
    var onCellBtnTapped: (()-> Void)?
    var reloadData: (()-> Void)?
    
    init(networkService: NetworkAPIService = Network()) {
        //Inject Network Dependency
        self.networkService = networkService
    }
    
    func viewDidLoad() {
        // API Calling, Parsing and updating Data Model
        fetchAPICall()
    }
    
    //For using in TableView
    func numberOfItems() -> Int {
        return userModel.count
    }
    
    //For using in TableView (Preparing UI Friendly cell data, all formatting will be done by ViewModel)
    func homeCellViewModel(index: IndexPath) -> HomeTableCellViewModel {
        // Convert Data model to UI Friendly model
        let model = userModel[index.item]
        let labelText = "\(model.id) - " + model.name
        let btnTitle = "ID : \(model.id)"
        return HomeTableCellViewModel(labelText: labelText, buttonTitle: btnTitle)
    }
    
    func didEnterPasswordToValidate(password: String){
        //All validation logic will be here in ViewModel
        let isValid = password.count > 8
        onPasswordValidation?(isValid)
    }
    
    func didSelectRow(){
        onSelectRow?()
    }
    
    func cellBtnTapped() {
        onCellBtnTapped?()
    }
    

    func fetchAPICall() {
        // API Calling
        networkService.fetchAPICall(url: "") { [weak self] result in
            switch result {
            case .failure :
                print("")
            case .success(let data):
                // Parsing and updating Data Model
                self?.userModel = data
                self?.reloadData?()
            }
        }
    }
}
