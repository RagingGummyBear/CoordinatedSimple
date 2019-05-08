//
//  APIManager.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit

class APIManager {
    
    // MARK: - Comments CRUD
    func readAllComments() -> Promise<[CommentModel]>{
        return Promise { resolve in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadAllComments()).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
                }.map {
                    try JSONDecoder().decode([CommentModel].self, from: $0.data)
                }.done { result in
                    resolve.fulfill(result)
                }.catch { error in
                    resolve.reject(error)
            }
        }
    }
    
    func readAllPosts() -> Promise<[PostModel]>{
        return Promise { resolve in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadAllPosts()).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
                }.map {
                    try JSONDecoder().decode([PostModel].self, from: $0.data)
                }.done { result in
                    resolve.fulfill(result)
                }.catch { error in
                    resolve.reject(error)
            }
        }
    }
    
    // MARK: - TODOs CRUD
    func readAllTODOs() -> Promise<[ToDoModel]> {
        return Promise { resolve in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadAllToDos()).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
                }.map {
                    try JSONDecoder().decode([ToDoModel].self, from: $0.data)
                }.done { result in
                    resolve.fulfill(result)
                }.catch { error in
                    resolve.reject(error)
            }
        }
    }
    
    func readTODO (todoId: Int) -> Promise<ToDoModel> {
        return Promise { resolve in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadAllToDos()).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
                }.map {
                    try JSONDecoder().decode(ToDoModel.self, from: $0.data)
                }.done { result in
                    resolve.fulfill(result)
                }.catch { error in
                    resolve.reject(error)
            }
        }
    }
    
    
    func updateTODO (todo: ToDoModel){
        // 
    }
    
    func deleteTODO (todoId: Int){
        //
    }
    
    func createTODO (todo: ToDoModel) {
        //
    }
    
    // MARK: - Users CRUD
    func getAllUsers() -> Promise<[UserModel]> {
        return Promise { resolve in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createAllUsersUrlRequest()).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
                }.map {
                    try JSONDecoder().decode([UserModel].self, from: $0.data)
                }.done { result in
                    resolve.fulfill(result)
                }.catch { error in
                    resolve.reject(error)
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
    
    func updateUser(userId: Int, user: UserModel){
        //
    }
    
    func deleteUser(userId: Int){
        //
    }
    
    func createUser(user: UserModel){
        //
    }
    
    // MARK: - Others.
    
    func readTODOs (from userId: Int) -> Promise<[ToDoModel]> {
        return Promise { resolve in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadToDoFromUserIdRequest(from: userId)).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
                }.map {
                    try JSONDecoder().decode([ToDoModel].self, from: $0.data)
                }.done { result in
                    resolve.fulfill(result)
                }.catch { error in
                    resolve.reject(error)
            }
        }
    }
    
    func readAllAlbums() -> Promise<[AlbumModel]> {
        return Promise { seal in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadAllAlbums()).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
                }.map {
                    try JSONDecoder().decode([AlbumModel].self, from: $0.data)
                }.done { result in
                    seal.fulfill(result)
                }.catch { error in
                    seal.reject(error)
            }
        }
    }
    
    func readAlbum(albumId: Int) -> Promise<AlbumModel> {
        return Promise { seal in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadAlbumIdRequest(albumId: albumId)).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
                }.map {
                    try JSONDecoder().decode(AlbumModel.self, from: $0.data)
                }.done { result in
                    seal.fulfill(result)
                }.catch { error in
                    seal.reject(error)
            }
        }
    }
    
    func readAlbums(from userId: Int) -> Promise<[AlbumModel]> {
        return Promise { resolve in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadAlbumFromUserIdRequest(from: userId)).validate()
                // ^^ we provide `.validate()` so that eg. 404s get converted to errors
                }.map {
                    try JSONDecoder().decode([AlbumModel].self, from: $0.data)
                }.done { result in
                    resolve.fulfill(result)
                }.catch { error in
                    resolve.reject(error)
            }
        }
    }
    
    func readAllPhotos() -> Promise<[PhotoModel]> {
        return Promise { seal in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadAllPhotos()).validate()
                }.map {
                    try JSONDecoder().decode([PhotoModel].self, from: $0.data)
                }.done { result in
                    seal.fulfill(result)
                }.catch { error in
                    seal.reject(error)
            }
        }
    }
    
    func readPhotos(from albumId: Int) -> Promise<[PhotoModel]> {
        return Promise { resolve in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadPhotoFromAlbumIdRequest(from: albumId)).validate()
                }.map {
                    try JSONDecoder().decode([PhotoModel].self, from: $0.data)
                }.done { result in
                    resolve.fulfill(result)
                }.catch { error in
                    resolve.reject(error)
            }
        }
    }
    
    func readPhotos(fromUser userId: Int) -> Promise<[PhotoModel]> {
        return Promise { resolve in
            firstly {
                URLSession.shared.dataTask(.promise, with: try createReadPhotoFromUserIdRequest(userId: userId)).validate()
                }.map {
                    try JSONDecoder().decode([PhotoModel].self, from: $0.data)
                }.done { result in
                    resolve.fulfill(result)
                }.catch { error in
                    resolve.reject(error)
            }
        }
    }
    
    func fetchUIImage(photo: PhotoModel) -> Promise<UIImage> {
        return Promise { resolve in
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data( contentsOf: URL(string: photo.url)!)
                    resolve.fulfill(UIImage(data: data)!)
                } catch let error {
                    resolve.reject(error)
                }
            }
        }
    }
    
    /* ********************** */
    // Request prep functions //
    /* ********************** */
    
    // MARK: - Request functions
    
    /* ***************** */
    // Read All requests //
    private func createReadAllPosts() throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadAllComments() throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/comments"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadAllAlbums() throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/albums"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadAllPhotos() throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/photos"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadAllToDos() throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/todos"
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
    /* ****************************** */
    /* ****************************** */
    
    
    /* ************ */
    // Read with id //
    private func createReadUserIdRequest(userId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/users/\(userId)"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadPostIdRequest(postId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/posts/\(postId)"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadCommentIdRequest(commentId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/comments/\(commentId)"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadAlbumIdRequest(albumId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/albums/\(albumId)"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadTodoIdRequest(todoId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/todos/\(todoId)"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    /* ****************************** */
    /* ****************************** */
    
    /* *************** */
    // Other functions //
    /* *************** */
    
    private func createReadToDoFromUserIdRequest(from userId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/todos?userId=\(userId)"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadAlbumFromUserIdRequest(from userId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/albums?userId=\(userId)"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadPhotoFromAlbumIdRequest(from albumId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/photos?albumId=\(albumId)"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadPhotoFromUserIdRequest(userId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/users/\(userId)/photos"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }

    /* ****************************** */
    /* ****************************** */
    
    private func prepareGetRequest(request: inout URLRequest) -> URLRequest {
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
}
