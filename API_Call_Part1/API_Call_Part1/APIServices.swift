//
//  APIHandler.swift
//  API_Call_UsingCompletionHandler
//
//  Created by Ambreen Bano on 21/09/25.
//

import Foundation

final class APIServices {
    static let shared = APIServices()
    private init(){}
    
    func fetchData(url: String, completion: @escaping (myModel?, Error?) -> Void){
        DispatchQueue.global().async { //API Call on BG Thread
            NetworkInteractor.fetchData(url: url) { (result: Result<myModel, Error>) in //In case of generics we explecity need to mention type of the parameter (param:Type)
                DispatchQueue.main.async { //API Response send on Main Thread
                    switch result {
                    case let .failure(error): // we can give let inside our outside also
                        completion(nil, error)
                    case .success(let model):
                        completion(model, nil)
                    }
                }
            }
        }
    }
    
    func fetchJSONData(url: String, completion: @escaping ([AnyHashable:Any]?, Error?) -> Void){
        DispatchQueue.global().async { //API Call on BG Thread
            NetworkInteractor.fetchJsonData(url: url) { (result) in //In normal case (NOT generic) we don't need to mention type of the parameter (param)
                DispatchQueue.main.async { //API Response send on Main Thread
                    switch result {
                    case .failure(let error):
                        completion(nil, error)
                    case .success(let model):
                        completion(model, nil)
                    }
                }
            }
        }
    }
}
