//
//  ViewController.swift
//  InterviewPractice_1
//
//  Created by Ambreen Bano on 16/08/25.
//

import UIKit

//CocoaPods - dependency manager for iOS projects. It simplifies the process of integrating and managing third-party libraries within Xcode projects.
//Manages libraries via a Podfile.
//It modifies your Xcode workspace by creating a .xcworkspace with Pods integrated.
//📌 How to add a library with CocoaPods:
//sudo gem install cocoapods
//pod init
//Open Podfile and add dependencies - pod 'Alamofire', '~> 5.8'
//pod install
//open project via .xcworkspace (not .xcodeproj).


//Swift Package Manager (SPM) - Apple’s native dependency manager.
// Built into Xcode (since Xcode 11).
//Uses Package.swift or Xcode GUI.
//Doesn’t create external workspaces — integrates directly with your project.
//📌 How to add a library with SPM:
//In Xcode → File > Add Packages…
//Enter GitHub URL of the package (e.g. https://github.com/Alamofire/Alamofire).
//Choose version rules (e.g. "Up to Next Major 5.0.0 < 6.0.0").
//Xcode fetches, compiles, and integrates automatically.

//NOTE : With CocoaPods, you open the .xcworkspace because CocoaPods generates an extra Pods project.
//With Swift Package Manager, packages are integrated natively, so you just use the normal .xcodeproj.



//Alamofire - Swift-based HTTP 3rd party networking library built on top of URLSession.It simplifies making network requests, handling responses, encoding/decoding parameters, and managing things like headers, authentication, and multipart uploads.








//A sandbox in iOS is a security mechanism that isolates each app from the rest of the system and other apps. Provide Security -Prevents apps from reading/modifying data of other apps.
//All sandbox storage is private to app. can't be shared with other apps or app extensions widgets.
//sandboxpath/Library/Preferences/ plist file
//sandbox/Library/Caches/Cached data
//App Sandbox (com.example.MyApp)
//├── Documents/           // User files
//├── Library/
//│   ├── Preferences/     // UserDefaults stored here
//│   └── Caches/          // Temporary cache
//└── tmp/                 // Temp files



//1. UserDefaults data is stored in a property list (plist) file on the device. use for
//Use to store small user prference data on device
//Data is not encrypted. it is plain
//Stored inside of an app's sandbox
//Deleted when app is deleted

//2. Core Data - Apple’s framework for managing the model layer in an iOS/macOS app.
//It allows you to store, retrieve, and manage data locally on the device.
//Supports object graph management, relationships, queries, and persistence.
//Core Data is not a database, but it usually uses SQLite under the hood for storage.
//Use to store user large data or API Cache on device
//Data is not encrypted. it is plain
//Stored inside of an app's sandbox
//Deleted when app is deleted
//Use cases:
    //Saving user data offline (like notes, tasks, settings)
    //Managing relationships between objects (like users and posts)
    //Caching API responses
                                    

//3.Keychain is Apple’s secure storage system on device.
//It’s used to store small pieces of sensitive data like: Passwords,API tokens, Encryption keys, Certificates
//Data is encrypted.
//App-Specific (but can be shared between apps using Keychain Access Groups).
//Keychain data on iOS is stored outside of an app's sandbox
//Not Deleted even when app is deleted




//4. App Groups allow multiple apps or app extensions from the same developer to share data securely. They provide a shared container for things like shared UserDefaults or files. This is commonly used to share data between a main app and its extensions (like widgets, Siri intents).
// UserDefaults(suiteName: "group.com.mycompany.shared")
// suiteName is group identifier, all use same group to access shared data
// When we enable an App Group (group.com.mycompany.shared), iOS creates a special shared container, separate from the app’s sandbox.



//Unit Test vs UI Test
//Unit Test - XCTest (Framework for unit testing.)
//UI Test - XCTest and XCUIApplication
//Unit tests verify small pieces of code in isolation and are fast to run, while UI tests simulate real user interactions with the app, verifying end-to-end flows but are slower and more brittle. Both are essential: unit tests for code correctness, UI tests for user experience.
    //import XCTest
    //@testable import MyApp
    //
    //final class MathTests: XCTestCase {
    //    func testAddition() {
    //        let sum = 2 + 3
    //        XCTAssertEqual(sum, 5)  // ✅ logic correctness
    //    }
    //}
    


//Test Mocking - Mocking means creating a fake object to test your code in isolation.
//Instead of calling the real network/database/service you replace it with a mock that gives controlled, predictable responses.
//Calling server in testing is not good.
//We can mock all edge error cases also to test with Mock data
//WE can create protocol and create Mock class to adopt that protocol to test the protocol functions, like fetchAPICall protocol method.

//Test Async method or code using Async/await
//Old way is expectation.fulfill() and wait(for:expectation,timeout:10)

//Tools & Debugging
//Instruments - Performance, memory, leaks, CPU profiling.
//Memory Leaks - Use Leaks Instrument to detect retain cycles.
//Symbolication - is the process of converting memory addresses in crash logs into human-readable symbols (function names, file names, and line numbers).
//It uses dSYM(Debug Symbol file) files, which are generated at build time.
//Xcode -> Organizer → automatically symbolicates crash logs when dSYMs are uploaded.


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let question1 = Question1()
        question1.runQuestions()
        
        let question11 = Question11()
        question11.runQuestions()
    }
}


struct UserModel: Codable {
    var userName: String
    var id: Int?
    
    enum codingKeys: String, CodingKey {
        case userName = "user_name"
        case id = "user_id"
    }
}

enum APIErrors: Error {
    case inValidURL
    case badRequest
    case parsingError
}


class APIService {
    
    func fetch(url: String) async throws -> UserModel {
        guard let url = URL(string: url) else {
            throw APIErrors.inValidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            throw APIErrors.badRequest
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decodeData = try decoder.decode(UserModel.self, from: data)
        return decodeData
    }
    
    func createUser(url: String, dict: [String:String]) async throws {
        guard let url = URL(string: url) else {
            throw APIErrors.inValidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postBody = try JSONEncoder().encode(dict)
        request.httpBody = postBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            throw APIErrors.badRequest
        }
    }
    
    func createUser1(url: String, user: UserModel) async throws  {
        guard let url = URL(string: url) else {
            throw APIErrors.inValidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postBody = try JSONEncoder().encode(user)
        request.httpBody = postBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            throw APIErrors.badRequest
        }
    }
    
    
    
    
    func fetch1(url: String) async -> Result<UserModel,APIErrors> {
        guard let url = URL(string: url) else {
            return .failure(.inValidURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return .failure(.badRequest)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let decodeData = try decoder.decode(UserModel.self, from: data)
            return .success(decodeData)
        } catch {
            return .failure(.badRequest)
        }
    }
    
    func callAPITofetchData() {
        Task {
            let result = await fetch1(url: "MyURLString")
            switch result {
            case .success(let successData):
                print(successData.userName)
            case .failure(let error):
                if error == .badRequest {
                    print("badRequest")
                }
            }
        }
    }
    
}
