//
//  NetworkInteractor.swift
//  API_Call_UsingCompletionHandler
//
//  Created by Ambreen Bano on 21/09/25.
//

import Foundation

//final class as inheritance is not required
final class NetworkInteractor {
    
    //static so we can use it on class name
    static func fetchJsonData(url: String, completion: @escaping (Result<[AnyHashable:Any], Error>)-> Void){
        guard let urlString = URL(string: url) else {
            let noUrlStringError = NSError(domain: "URL Error", code: 0, userInfo: nil)
            completion(.failure(noUrlStringError))
            return
        }
        let urlRequest = URLRequest(url: urlString)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "No Data", code: 1, userInfo: nil)
                completion(.failure(noDataError))
                return
            }
            do {
                if let model = try JSONSerialization.jsonObject(with: data) as? [AnyHashable:Any] { //Old way JSONSerialization, now we use JSONDecoder
                    completion(.success(model))
                } else {
                    let noDataError = NSError(domain: "Invalid Json Data", code: 1, userInfo: nil)
                    completion(.failure(noDataError))
                }
            } catch let modelDecodingError {
                completion(.failure(modelDecodingError))
            }
            
        }
        task.resume()
    }
    
    
    //Generic API Call
    static func fetchData<T: Codable>(url: String, completion: @escaping (Result<T, Error>)-> Void){
        guard let urlString = URL(string: url) else {
            let noUrlStringError = NSError(domain: "URL Error", code: 0, userInfo: nil)
            completion(.failure(noUrlStringError))
            return
        }
        let urlRequest = URLRequest(url: urlString)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "Invalid Data", code: 1, userInfo: nil)
                completion(.failure(noDataError))
                return
            }
            do {
                let model = try JSONDecoder().decode(T.self, from: data) //New way uses JSONDEcoder
                completion(.success(model))
            } catch let modelDecodingError {
                completion(.failure(modelDecodingError))
            }
            
        }.resume()
    }
}
