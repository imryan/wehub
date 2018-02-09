//
//  Issue.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/7/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import Foundation

struct Issue : Codable {
    
    let number: Int?
    let title: String?
    let body: String?
    let createdAt: Date?
    let state: State?
    
    enum State : String, Codable {
        case Open = "open"
        case Closed = "closed"
    }
    
    private enum CodingKeys: CodingKey, String {
        case createdAt = "created_at"
        case number
        case title
        case body
        case state
    }
}
