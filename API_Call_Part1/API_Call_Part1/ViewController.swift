//
//  ViewController.swift
//  API_Call_UsingCompletionHandler
//
//  Created by Ambreen Bano on 21/09/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let api = APIServices.shared
    var listData: [myJsonData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Any UITableViewCell/header/subView is created using only.xib file. storyboard is use for ViewControllers
        tableView.register(UINib(nibName: "myTableCell", bundle: .main), forCellReuseIdentifier: "myTableCell")
        tableView.register(UINib(nibName: "Header", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        fetchListData()
        //        tableView.tableHeaderView = Header(frame: CGRect(x: 0, y: 0, width: 500, height: 200))
        //        tableView.tableFooterView = UIView()
    }
    
    private func fetchListData(){
        api.fetchJSONData(url: "myURL") { [weak self] (data, error) in
            //UI Update should be on Main thread, already receiving completion handler on main thread here from fetchJSONData
            guard let data = data else {
                self?.listData = nil
                self?.tableView.isHidden = true
                let alert = UIAlertController(title: "Oh Ho!", message: "No Data Receive", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(alertAction)
                self?.present(alert, animated: true)
                return
            }
            self?.tableView.isHidden = false
            self?.listData = [myJsonData(dict: data)]
            self?.tableView.reloadData()
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myTableCell", for: indexPath) as? myTableCell {
            //            if let dataModel = listData, let cellData = dataModel[safe: indexPath.row] { //for using safe need to have extension Collections{}
            //                cell.title.text = cellData.title
            //                cell.subTitle.text = cellData.subtitle
            //                return cell
            //            }
            
            //            if let dataModel = listData { //listData is optional so if let is required
            //                let cellData = dataModel[indexPath.row]  //Non-Optional becuase var listData: [myJsonData]?, we can see myJsonData is non-optional, but it can crash if index is out of bound so first check indexPath.row before using index directly. as shown below
            //                cell.title.text = cellData.title
            //                cell.subTitle.text = cellData.subtitle
            //                return cell
            //            }
            
            if let dataModel = listData, dataModel.count > indexPath.row { //listData is optional so if let is required
                let cellData = dataModel[indexPath.row]  // first check indexPath.row before using index directly otherwise it will crash
                cell.title.text = cellData.title
                cell.subTitle.text = cellData.subtitle
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Header Title"
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? Header {
            return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
}




//For using safe index we need this extension for collections
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
