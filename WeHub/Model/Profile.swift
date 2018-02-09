//
//  Profile.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/6/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import UIKit

struct Profile : Codable {
    
    let name: String?
    let bio: String?
    let location: String?
    let username: String?
    let avatarURL: String?
    let followers: Int?
    let following: Int?
    
    private enum CodingKeys: String, CodingKey {
        case username = "login"
        case avatarURL = "avatar_url"
        case location
        case name
        case bio
        case followers
        case following
    }
}

extension Profile {
    
    func fetchAvatarImage(block: @escaping (_ image: UIImage?) -> ()) {
        guard let url = URL(string: avatarURL!) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let data = data {
                    let image = UIImage(data: data)
                    block(image)
                }
            }
            block(nil)
        }.resume()
    }
}
