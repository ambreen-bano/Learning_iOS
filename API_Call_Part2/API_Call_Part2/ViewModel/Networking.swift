//
//  Networking.swift
//  ProjP_2025
//
//  Created by Ambreen Bano on 18/07/25.
//

import Foundation

enum MyError: Error {
    case error
    case emptyURL
    case incorrectResponse
    case emptyResponse
    case encoding
}


final class Networking { //final no one can inherit
    static let shared = Networking() //Singleton class , static only one single instance to use globally
    private init(){} //private init so no one can create instance of the class from outside
    
    
    //GET HTTPs API Calls - using handler
    
    func fetchDataWithHandler<T: Decodable>(urlString: String, handler:@escaping (Result<T,Error>)-> ()) {
        guard let url = URL(string: urlString) else {
            handler(.failure(MyError.emptyURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        
        //URLSession is automatically always run on BG thread from inside
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                handler(.failure(error ?? MyError.error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                handler(.failure(MyError.incorrectResponse))
                return
            }
            
            guard let jsonData = data else {
                handler(.failure(MyError.emptyResponse))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: jsonData)
                handler(.success(model))
            } catch {
                handler(.failure(MyError.incorrectResponse))
            }
        }.resume()
    }
    
    
    
    //GET HTTPs API Calls - using Async/await
    
    func fetchDataUsingAsync<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw MyError.emptyURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        //URLSession is automatically always run on BG thread from inside
        let (data, response) = try await URLSession.shared.data(for: urlRequest) //error is handled or getting in catch block, no need to read here
    
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            throw MyError.incorrectResponse
        }
        let outputModel = try JSONDecoder().decode(T.self, from: data)
        return outputModel
    }
    
    
    
    //POST HTTPs API Calls - using JSONEncoder
    
    func createDataWithPost<T: Decodable, U: Encodable>(urlString: String, body : U, handler:@escaping (Result<T,Error>)-> ()) {
        guard let url = URL(string: urlString) else {
            handler(.failure(MyError.emptyURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        } catch {
            handler(.failure(MyError.encoding))
            return
        }
        
        //URLSession is automatically always run on BG thread from inside
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                handler(.failure(error ?? MyError.error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                handler(.failure(MyError.incorrectResponse))
                return
            }
            
            guard let jsonData = data else {
                handler(.failure(MyError.emptyResponse))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: jsonData)
                handler(.success(model))
            } catch {
                handler(.failure(MyError.incorrectResponse))
            }
        }.resume()
    }
    
    
    
    //POST HTTPs API Calls - using JSONSerialization
    
    func createDataWithPost<T: Decodable>(urlString: String, bodyDict : [AnyHashable: Any], bodyString: String, handler:@escaping (Result<T,Error>)-> ()) {
        guard let url = URL(string: urlString) else {
            handler(.failure(MyError.emptyURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //urlRequest.httpBody = bodyString.data(using: .utf8)
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyDict)
        } catch {
            handler(.failure(MyError.encoding))
            return
        }
        
        //URLSession is automatically always run on BG thread from inside
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                handler(.failure(error ?? MyError.error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                handler(.failure(MyError.incorrectResponse))
                return
            }
            
            guard let jsonData = data else {
                handler(.failure(MyError.emptyResponse))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: jsonData)
                handler(.success(model))
            } catch {
                handler(.failure(MyError.incorrectResponse))
            }
        }.resume()
    }

}
