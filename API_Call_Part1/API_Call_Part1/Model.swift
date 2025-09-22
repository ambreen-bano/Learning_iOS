//
//  Model.swift
//  API_Call_UsingCompletionHandler
//
//  Created by Ambreen Bano on 01/10/24.
//

import Foundation

struct myModel: Codable {
    let title : String
    let subtitle: String
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}

//Manual parsing from JSON Dict
struct myJsonData {
    let title : String?
    let subtitle: String?
    
    init(dict: [AnyHashable:Any]) {
        self.title = dict["title"] as? String
        self.subtitle = dict["subTitle"] as? String
    }
}
