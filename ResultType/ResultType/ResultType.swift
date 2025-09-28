//
//  ResultType.swift
//  ResultType
//
//  Created by Ambreen Bano on 19/02/23.
//

import UIKit


/* enum Result <SuccessData: Any, FailureError: Error>{
 Case success(SuccessData)
 case failure(FailureError)
 }*/
//Result Type is Enum with associated values having only two cases
//SuccessData is the type of the value/data returned on success case.
//FailureError is Error (Comform Error Protocol) returned on Failure case.
//It makes API return type handling clean and easy


//Creating own enum error with type Error
enum MyError: Error { //Comfort Error Protocol
    case internetError
    case otherError
}

//Model Struct
struct MyModel: Decodable {
    let fact: String?
    let length: Int?
}

class ResultType: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAPIData { result in
            //Result is enum of two cases so we can use switch to handle it
            switch result {
            case .success(let data):
                print(data.fact)
            case .failure(let error):
                print(error.localizedDescription)
                
                //We can write like this also as let is outside
                // case let .failure(error):
                // print(error.localizedDescription)
                
                //We can write like this also without using associated value
                //case .failure:
                //break
            }
        }
        
        ResultTypeWithGenerics.fetchAPIData { (result: Result<MyModel,MyError>) in
            switch result {
            case .success(let data):
                print(data.fact)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    //@escaping handler will live even after the function execution completed
    //Use @escaping when time of execution is not fix like api call response time
    //By default handler are @nonescaping, and not live after function return or execution completion
    func fetchAPIData(handler:@escaping (Result<MyModel,Error>) -> Void){
        let url = URL(string: "https://catfact.ninja/fact")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "get"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let serverData = data else {
                handler(.failure(error!))
                return
            }
            do{
                let json = try JSONDecoder().decode(MyModel.self, from: serverData)
                handler(.success(json))
            } catch{
                handler(.failure(error))
            }
        }.resume()
    }
}


//Error case always of type - Error only, we can only success case data make Generic type
class ResultTypeWithGenerics {
    class func fetchAPIData<T: Decodable>(handler:@escaping (Result<T,MyError>) -> Void){
        let url = URL(string: "https://catfact.ninja/fact")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "get"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let serverData = data else {
                handler(.failure(.internetError))
                return
            }
            do{
                let json = try JSONDecoder().decode(T.self, from: serverData)
                handler(.success(json))
            } catch{
                handler(.failure(.otherError))
            }
        }.resume()
    }
    
}




//Can also use Result Type with do-catch blocks and try.
func readFile(filename: String) -> Result<String, Error> {
    do {
        let content = try String(contentsOfFile: filename)
        return .success(content)
    } catch {
        return .failure(error)
    }
}

func readFileContents() {
    let result = readFile(filename: "example.txt")
    
    switch result {
    case .success(let content):
        print("File content: \(content)")
    case .failure(let error):
        print("Error reading file: \(error)")
    }
}
