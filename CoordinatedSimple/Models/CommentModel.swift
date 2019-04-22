//
//  CommentModel.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation

class CommentModel: Codable {
    var postId:Int!
    var id:Int!
    var name:String!
    var email:String!
    var body:String!
    
    init(postId: Int, id: Int, name:String, email:String, body:String) {
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
    
    enum CodingKeys: String, CodingKey {
        case postId
        case id
        case name
        case email
        case body
    }
}
