//
//  Network.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 26/08/25.
//

import Foundation
import Combine


protocol NetworkAPIService {
    func fetchAPICall(url: String, handler: @escaping (Result<[UserModel], Error>)->())
    func fetchAPICallUsingPublisher(url: String) -> AnyPublisher<[UserModel], Error> 
}

class Network: NetworkAPIService {
    
    func fetchAPICall(url: String, handler: @escaping (Result<[UserModel], Error>)->()) {
        //Actual API Call to fetch data
        handler(.success([UserModel(id: 1, name: "Amber"), UserModel(id: 2, name: "Safia")]))
        
    }
    
    func fetchAPICallUsingPublisher(url: String) -> AnyPublisher<[UserModel], Error> {
        return URLSession.shared.dataTaskPublisher(for: URL(string: "myURL")!)
            .map { $0.data }
            .decode(type: [UserModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
