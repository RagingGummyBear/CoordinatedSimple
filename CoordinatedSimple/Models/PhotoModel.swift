//
//  ImageModel.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation

class PhotoModel: Codable {
    var albumId: Int!
    var id: Int!
    var title: String!
    var url: String!
    var thumbnailUrl:String!
    
    init(albumId: Int, id: Int, title:String, url:String, thumbnailUrl: String) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case albumId
        case id
        case title
        case url
        case thumbnailUrl
    }
}
