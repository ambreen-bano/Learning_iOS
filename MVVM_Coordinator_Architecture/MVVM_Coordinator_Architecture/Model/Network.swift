//
//  Network.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 26/08/25.
//

import Foundation


protocol NetworkAPIService {
    func fetchAPICall(url: String, handler: @escaping (Result<[UserModel], Error>)->())
}

class Network: NetworkAPIService {
    
    func fetchAPICall(url: String, handler: @escaping (Result<[UserModel], Error>)->()) {
        //Actual API Call to fetch data
        handler(.success([UserModel(id: 1, name: "Amber"), UserModel(id: 2, name: "Safia")]))
    }
}
