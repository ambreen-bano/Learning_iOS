//
//  Model.swift
//  ProjP_2025
//
//  Created by Ambreen Bano on 18/07/25.
//

import Foundation

struct MyModel: Codable {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
