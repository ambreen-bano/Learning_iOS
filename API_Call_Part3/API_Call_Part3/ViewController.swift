//
//  ViewController.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 23/08/25.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let vc = FetchDataVC()
            await vc.runTask()
        }
    }
}




class FetchDataVC {
    //Dependency Injection to inject APIServices
    let apiService: APIServices
    init(apiService: APIServices = NetworkManager()) {
        self.apiService = apiService
    }
    
    func runTask() async {
        //Using Completion Handler
        apiService.fetch(urlStr: "myURL") { result in
            switch result {
            case .failure(let error):
                print("\n Error in Fetching Data:\(error)")
            case .success(let data):
                print(data)
            }
        }
        
        
        //Using Async Await
        do {
            let data = try await apiService.fetchAsync(urlStr: "myURL")
            print(data)
        } catch {
            print("\n Error in Fetching Data:\(error)")
        }
        
    
        do {
            let data = try await apiService.createAsync(urlStr: "myURL", data: ["user_name": "Amber"])
            print(data)
        } catch {
            print("\n Error in Fetching Data:\(error)")
        }
    }
}






//Non-optional properties must exist in JSON. Otherwise, decoding fails. It will throw DecodingError
//If you want safe decoding when keys may be missing, you must either:
//1.Make the property optional, or
//2.Use custom init(from:) with decodeIfPresent.


struct Model: Codable { //Should be CODABLE
    var name: String
    var id: Int
    
    //IF chances that server can not send this these key then make it - optional or init implement
    let nickName: String? // 1. OPTIONAL
    let fullName: String // 2. init(from: Decoder)
    
    enum CodingKeys: String, CodingKey {
        case name = "user_name"
        case id = "user_id"
        case nickName = "nick_name"
        case fullName = "full_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? "UnKnown"
        self.nickName = try container.decodeIfPresent(String.self, forKey: .id) ?? "UnKnown"
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "UnKnown"
        self.id = try container.decode(Int.self, forKey: .id) //If it is non-optional we can remove default
    }
}



enum APIErrors: Error { //Custom Error enum
    case URLError
    case ResponseError
    case DecodingError
    case Error
}



protocol APIServices {
    func fetch(urlStr: String, handler: @escaping ((Result<[Model], Error>)-> Void) ) //GET
    func fetchAsync(urlStr: String) async throws -> Result<[Model], Error> //GET
    func createAsync(urlStr: String, data: [String:String]) async throws -> Result<Model, Error> //POST
}


class NetworkManager: APIServices {
    //Using completion handler
    func fetch(urlStr: String, handler: @escaping ((Result<[Model],Error>)-> Void)) {
        guard let url = URL(string: urlStr) else {
            handler(.failure(APIErrors.URLError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                handler(.failure(error ?? APIErrors.Error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode), let data = data else {
                handler(.failure(APIErrors.ResponseError))
                return
            }
            
            do {
                let modelData = try JSONDecoder().decode([Model].self, from: data) //.self is on complete return type [Model] not on [Model.self]
                handler(.success(modelData))
            } catch {
                handler(.failure(APIErrors.DecodingError))
            }
        }.resume()
    }
    
    
    
    
    
    
    //GET using Async await (if using Result then no need of throw, if directly returning [Model] then can use throw for error handling)
    //async - await
    //try - do catch
    //DON'T handle throws and Result<data,Error> together
    //Using async/await
    func fetchAsync(urlStr: String) async -> Result<[Model], Error> {
        
        guard let url = URL(string: urlStr) else {
            return .failure(APIErrors.URLError)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return  .failure(APIErrors.ResponseError)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase //keyDecodingStrategy to parse json
            let modelData = try decoder.decode([Model].self, from: data)
            return .success(modelData)
        } catch {
            return .failure(error)
        }
    }
    
    
    
    
    
    //POST
    func createAsync(urlStr: String, data: [String:String]) async throws -> Result<Model, Error> {
        guard let url = URL(string: urlStr) else {
            return .failure(APIErrors.URLError)
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(data)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return  .failure(APIErrors.ResponseError)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let modelData = try decoder.decode(Model.self, from: data)
            return .success(modelData)
        } catch {
            return .failure(error)
        }
    }
    
}


//How to create URL with query params
//let url = URL(string: "https://api.themoviedb.org/3/discover/movie")!
//var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
//let queryItems: [URLQueryItem] = [
//    URLQueryItem(name: "include_adult", value: "false"),
//    URLQueryItem(name: "include_video", value: "false"),
//    URLQueryItem(name: "language", value: "en-US"),
//    URLQueryItem(name: "page", value: "1"),
//    URLQueryItem(name: "sort_by", value: "popularity.desc"),
//]
//components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
//
//var request = URLRequest(url: components.url!)
//request.httpMethod = "GET"
//request.timeoutInterval = 10
//request.allHTTPHeaderFields = ["accept": "application/json"]
//
//let (data1, _) = try await URLSession.shared.data(for: request)
//print(String(decoding: data1, as: UTF8.self))

