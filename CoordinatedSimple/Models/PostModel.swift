//
//  PostModel.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation

class PostModel: Codable {
    var userId: Int!
    var id: Int!
    var title: String!
    var body: String!
    
    init(userId:Int, id:Int, title:String, body:String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
}

/*
 
 {
 "userId": 1,
 "id": 1,
 "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
 "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
 }
 
 */
