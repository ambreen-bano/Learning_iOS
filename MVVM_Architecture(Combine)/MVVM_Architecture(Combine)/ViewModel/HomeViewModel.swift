//
//  HomeViewModel.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 26/08/25.
//

import Foundation
import Combine

//This is for HomeVC
//ViewModel Handles formattinmgs, validations, API Calls
class HomeViewModel {
    
    let networkService: NetworkAPIService
    
    //Publishers
    //VC subscribe these properties, when VM changes these property, VC automatically listen and update UI
    @Published private(set) var userModel: [UserModel] = []
    @Published private(set) var isPasswordValid: Bool = false
    @Published private(set) var onRowSelectMsg: String = ""
    @Published private(set) var onButtonTappedMsg: String = ""
    
    //MANUAL Publishers
    //ViewModel DEFINE Manual Publisher to receive input from VC (VC will manually send these publisher, when VC receive UI interaction events)
    let didEnterPasswordToValidate = PassthroughSubject<String,Never>()
    let didSelectRow = PassthroughSubject<Void,Never>()
    let cellBtnTapped = PassthroughSubject<Void,Never>()

    var cancellable = Set<AnyCancellable>() //Property to Store Active Subscribers, subscribers will destroy when class destroy
    var passwordStr = ""
    
    init(networkService: NetworkAPIService = Network()) {
        //Inject Network Dependency
        self.networkService = networkService
    }
    
    func viewDidLoad() {
        // API Calling
        // Parsing and updating Data Model
        bindViewModelToViewController()
        fetchAPICall()
    }
    
    //For using in TableView
    func numberOfItems() -> Int {
        return userModel.count
    }
    
    //For using in TableView
    func homeCellViewModel(index: IndexPath) -> HomeTableCellViewModel {
        // Convert Data model to UI Friendly model
        let model = userModel[index.item]
        let labelText = "\(model.id) - " + model.name
        let btnTitle = "ID : \(model.id)"
        return HomeTableCellViewModel(labelText: labelText, buttonTitle: btnTitle)
    }
    
    func bindViewModelToViewController(){
        // VC will send these publisher and viewModel will receive via subscriber
    
        didEnterPasswordToValidate
            .map { $0.uppercased() } //showing how we can apply filters to the value we are receiving before sending it to sink {} block
            .sink { [weak self] password in
            let isValid = password.count > 8
            self?.isPasswordValid = isValid
        }.store(in: &cancellable) //Mandatory to store Active Subscribers, otherwise we will not receive them
        
        //Just for showing how we can use assign and update properties using key path \.propertName
        //didEnterPasswordToValidate.assign(to: \.passwordStr, on: self)
        //    .store(in: &cancellable)
        
        
        //This is for tableviewCell click
        didSelectRow.sink {[weak self] _ in
            self?.onRowSelectMsg = "Row Clicked"
        }.store(in: &cancellable)
        
        //This is for tableviewCell Btn click
        cellBtnTapped.sink { [weak self]  _ in
            self?.onButtonTappedMsg = "Button Tapped"
        }.store(in: &cancellable)
    }
 

    func fetchAPICall() {
        // API Calling
        
        //        Old Way to call API
        //        networkService.fetchAPICall(url: "") { [weak self] result in
        //            switch result {
        //            case .failure :
        //                print("")
        //            case .success(let data):
        //                // Parsing and updating Data Model
        //                self?.userModel = data
        //            }
        //        }
        
        networkService.fetchAPICallUsingPublisher(url: "")
            .sink { completion in
                switch completion {
                case .failure:
                    break
                case .finished:
                    print("Finished")
                }
            } receiveValue: {[weak self]  model in
                self?.userModel = model
            }
            .store(in: &cancellable)
        
    }
}

