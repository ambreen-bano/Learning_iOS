//
//  Generics.swift
//  Generics
//
//  Created by Ambreen Bano on 19/02/23.
//

import UIKit

//Generics for code reusability

class Generics: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output1 = add1(value1: 10, value2: 20)
        print(output1)
        let output2 = add1(value1: 10.5, value2: 20.5)
        print(output2)
        
        
        
        let output3 = add2(value1: "Amber", value2: "Iram")
        print(output3)
        let output4 = add2(value1: [1,2,3], value2: [4,5,6])
        print(output4)
        let output5 = add2(value1: ["a","b"], value2: ["c","d"])
        print(output5)
        //Not working for Numeric
        //let output6 = add2(value1: 10, value2: 20)
        //print(output6)
        //Not working for dictionary
        //let output6 = add2(value1: ["Amber": 1], value2: ["Iram":2])
        //print(output6)
        
        
        let output7 = add3(values: 10,20,30)
        print(output7)
        let output8 = add3(values: 10,20,30,50,60,70)
        print(output8)
        
        
        /*______________________________________*/
        
        APICaller.shared.fetchAPIData(urlString: "https://api.publicapis.org/entries") { (data: MyModel1) in
            print(data.count)
            print(data.entries?.first?.Description)
            print(data.entries?.first?.Link)
        }
        
        
        APICaller.shared.fetchAPIData(urlString: "https://catfact.ninja/fact") { (data: MyModel2) in
            print(data.fact)
        }
    }
    
    
    /*______________________________________*/
    
    //Generic to add two numeric values like int float double
    func add1<T:Numeric>(value1:T, value2:T) -> T {
        return value1 + value2
    }
    
    //Generic to add two Collection values like strings, array
    func add2<T:RangeReplaceableCollection>(value1: T, value2: T) -> T {
        return value1 + value2
    }
    
    //Generic to add N numbers of numeric values like int float double
    func add3<T:Numeric>(values: T...) -> T { //Any number of params we can give if using ...
        return values.reduce(0) {$0 + $1}
    }
    
    
    /*______________MODELS________________________*/
    
    struct MyModel1: Codable {
        //"https://api.publicapis.org/entries"
        //Codable type so we can decode it in our generic fetch API method which expect T: Codable
        //For using JSONDecoder() need to use property name exactly same as key strings
        let count: Int?
        let entries: [APIDetails]?
        
        struct APIDetails: Codable {
            let API: String?
            let Description: String?
            let Link: String?
            let Auth: String?
            let HTTPS: Bool?
            let Cors: String?
            let Category: String?
        }
    }
    
    struct MyModel2: Codable {
        //https://catfact.ninja/fact
        let fact: String?
        let length: Int?
    }
}


class APICaller {
    
    static let shared = APICaller() //singlton, global instance of the class
    private init(){
        //it is private so no one can initalize it from outside to maintain it as singlton
    }
    
    //Generic API Calling Method
    func fetchAPIData<T:Codable>(urlString: String, handler: @escaping (T) -> Void) {
        //T is Codable type so any object of codable type can call this method
        
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "get"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let serverData = data else {
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(T.self, from: serverData)
                DispatchQueue.main.async {
                    //Data fetching is on background thread so call handler always on main thread
                    handler(jsonData)
                }
            }
            catch {
                //Here, in case of failure, we are not calling handler. But we should always call handler to send information even error so if we want to show some Error view we can do there
                print("Catch Called, Decoding Failed")
            }
        }.resume()
    }
    /*______________________________________*/
}
