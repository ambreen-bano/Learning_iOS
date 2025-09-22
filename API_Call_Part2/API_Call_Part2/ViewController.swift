//
//  ViewController.swift
//  ProjP_2025
//
//  Created by Ambreen Bano on 17/07/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var model: [MyModel] = [MyModel(name: "Amber", age: 33), MyModel(name: "Iram", age: 34)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "tableCell", bundle: .main), forCellReuseIdentifier: "tableCell")
        
        apiCallUsingCompletionHandler()
        apiCallUsingAsyncAwaitMainActorMethod()
        apiCallUsingAsyncAwaitUsingMainActorForReloadData()
    }
    
    
    
    //Option 1 : DispatchQueue.main
    func apiCallUsingCompletionHandler(){
        //No need to dispatch API calls to background manually → URLSession already from inside it is on BG thread only.
        Networking.shared.fetchDataWithHandler(urlString: "Url string") { [weak self] (result: Result<[MyModel],Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case let .success(model):
                    self.model = model
                    self.tableView.reloadData()
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    
    
    //Option 2 : @MainActor Method
    @MainActor //Option1 : Entire Method will run on main thread, fetchDataUsingAsync is from inside is on background Thread. once response come method next line of code started again to eun on main thread
    func apiCallUsingAsyncAwaitMainActorMethod() {
        //self is Parent
        Task { //Child Task
            do {
                //No need to dispatch API calls to background manually → URLSession already from inside it is on BG thread only.
                let model: [MyModel] = try await Networking.shared.fetchDataUsingAsync(urlString: "Url string")
                self.model = model //No [weak self] handling is required because it is not @escaping closure, it is structured concurreny, if self is deallocated then child task also canceld. Task{} or async methods is not retaining self like closure does.
                tableView.reloadData()
            } catch {
                print("\(error)")
            }
        }
    }
    
    
    
    
    //Option 3 : MainActor Code Block
    func apiCallUsingAsyncAwaitUsingMainActorForReloadData() {
        Task {
            do {
                //No need to dispatch API calls to background manually → URLSession already from inside it is on BG thread only.
                let model: [MyModel] = try await Networking.shared.fetchDataUsingAsync(urlString: "Url string")
                
                await MainActor.run { //Option2: This Block of code will run on main thread
                    self.model = model
                    tableView.reloadData()
                }
            } catch {
                print("\(error)")
            }
        }
    }
}




extension ViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as? tableCell {
            if model.count > indexPath.row { //model is non-optional, but index need to check
                let cellData = model[indexPath.row]
                cell.configureCell(name: cellData.name)
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension ViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
