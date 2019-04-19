//
//  APIManager.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import PromiseKit

class APIManager {
    
    func getAllUsers() -> Promise<[UserModel]> {
        return Promise { seal in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createAllUsersUrlRequest()).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
            }.map {
                try JSONDecoder().decode([UserModel].self, from: $0.data)
            }.done { result in
                seal.fulfill(result)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func readUser(userID: Int) -> Promise<UserModel> {
        return Promise { resolve in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadUserIdRequest(userId: userID)).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
            }.map {
                try JSONDecoder().decode(UserModel.self, from: $0.data)
            }.done { result in
                resolve.fulfill(result)
            }.catch { error in
                resolve.reject(error)
            }
        
        }
    }
    
    func updateUser(userId: Int){
        
    }
    
    func deleteUser(userId: Int){
        
    }
    
    func createUser(user: UserModel){
        
    }
    
    /* ********************** */
    // Request prep functions //
    /* ********************** */
    
    private func createReadUserIdRequest(userId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/users/\(userId)/"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createAllUsersUrlRequest() throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/users"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func prepareGetRequest(request: inout URLRequest) -> URLRequest {
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
}
