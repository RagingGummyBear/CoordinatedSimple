//
//  AlbumModel.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation

class AlbumModel: Codable {
    var userId: Int!
    var id: Int!
    var title: String!
    
    init(userId: Int, id: Int, title:String) {
        self.userId = userId
        self.id = id
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
    }
}
