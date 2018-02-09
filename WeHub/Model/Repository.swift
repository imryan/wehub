//
//  Repository.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/7/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import Foundation

struct Repository : Codable {
    
    let name: String?
    let description: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
    }
}
