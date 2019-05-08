//
//  DataProvider.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit
import Reachability

public class DataProvider {
    
    // MARK: - Properties
    let persistentStorage:PersistentStorage = KeyedArchiverHandler()
    let apiManager: APIManager = APIManager()
    let reachability = Reachability()!
    var onlineConnection = false
    
    init() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                self.onlineConnection = true
            } else {
                print("Reachable via Cellular")
                self.onlineConnection = true
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.onlineConnection = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

    }
    
    // MARK: - Users => CRUD
    func readAllUsers() -> Promise<[UserModel]>{
        if self.onlineConnection {
            return Promise { resolve in
                self.apiManager.getAllUsers().done { (users: [UserModel]) in
                    _ = self.persistentStorage.setUsersList(elems: users)
                    resolve.fulfill(users)
                    } .catch({ (error: Error) in
                        resolve.reject(error)
                    })
            }
        } else {
            return self.persistentStorage.readAllUsers()
        }
    }
    
    func readUser(userID: Int) -> Promise<UserModel> {
        if self.onlineConnection {
            return Promise { resolve in
                self.apiManager.readUser(userID: userID).done({ (user: UserModel) in
                    _ = self.persistentStorage.addUser(user: user) // WARNING Need to check if it already has the user or it will make duplicates
                    resolve.fulfill(user)
                }) .catch({ (error: Error) in
                    resolve.reject(error)
                })
                
            }
        } else {
            return self.persistentStorage.readUser(userID: userID)
        }
    }
    
    func updateUser(user: UserModel){
        // patch
    }
    
    func deleteUser(userId: Int){
        // delete
    }
    
    func createUser(user: UserModel){
        if self.onlineConnection {
            self.apiManager.createUser(user: user)
        }
        _ = self.persistentStorage.addUser(user: user)
        // put
    }
    
    
    // MARK: - TODOs => CRUD
    func readAllTODOs() -> Promise<[ToDoModel]> {
        if self.onlineConnection {
            return Promise { seal in
                self.apiManager.readAllTODOs().done({ (todos: [ToDoModel]) in
                    _ = self.persistentStorage.setTODOsList(elems: todos)
                    seal.fulfill(todos)
                }).catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        } else {
            return self.persistentStorage.readAllTODOs()
        }
    }
    
    func readTODO(todoId: Int) -> Promise<ToDoModel> {
        if self.onlineConnection {
            return self.apiManager.readTODO(todoId: todoId)
        } else {
            return self.persistentStorage.readTODO(todoId: todoId)
        }
    }
    
    func updateTODO(todo: ToDoModel){
        if self.onlineConnection {
            self.apiManager.updateTODO(todo: todo)
        }
        _ = self.persistentStorage.updateTODO(todo: todo)
    }
    
    func deleteTODO(todoId: Int){
        // delete
        // TODO
    }
    
    func createTODO(todo: ToDoModel){
        if self.onlineConnection {
            self.apiManager.createTODO(todo: todo)
        }
        _ = self.persistentStorage.createTODO(todo: todo)
    }
    
    // MARK: - Albums => CRUD
    func readAllAlbums() -> Promise<[AlbumModel]>{
        if self.onlineConnection {
//            self.apiManager.readAll
            return Promise { seal in
                self.apiManager.readAllAlbums().done({ (albums: [AlbumModel]) in
                    _ = self.persistentStorage.setAlbumsList(elems: albums)
                    seal.fulfill(albums)
                }).catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        } else {
            // Return
            return self.persistentStorage.readAllAlbums()
        }
    }
    
    func readAlbum(albumId: Int) -> Promise<AlbumModel> {
        if self.onlineConnection {
            return Promise { seal in
                self.apiManager.readAlbum(albumId: albumId).done({ (album: AlbumModel) in
                    _ = self.persistentStorage.createAlbum(album: album)
                    seal.fulfill(album)
                }).catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        } else {
            return self.persistentStorage.readAlbum(albumId: albumId)
        }
    }
    
    func updateAlbum(album: AlbumModel){
        // patch
    }
    
    func deleteAlbum(albumId: Int){
        // delete
    }
    
    func createAlbum(album: AlbumModel){
        // put
        if self.onlineConnection {
            
        }
        _ = self.persistentStorage.createAlbum(album: album)
    }
    
    
    // MARK: - Photos => CRUD
    func readAllPhotos() -> Promise<[PhotoModel]> {
        if self.onlineConnection {
            return Promise { seal in
                self.apiManager.readAllPhotos().done({ (photos: [PhotoModel]) in
                    _ = self.persistentStorage.setPhotosList(elems: photos)
                    seal.fulfill(photos)
                }) .catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        } else {
            return self.persistentStorage.readAllPhotos()
        }
    }
    
    func readPhoto(photoId: Int) -> Promise<PhotoModel> {
        return  Promise { resolve in
            
        }
    }
    
    func updatePhoto(photo: PhotoModel) -> Promise<PhotoModel> {
        
        return  Promise { resolve in
            
        }
    }
    
    func deletePhoto(photoId: Int) -> Promise<Bool> {
        
        return  Promise { resolve in
            
        }
    }
    
    func createPhoto(photo: PhotoModel) {
        
        if self.onlineConnection {
            
        }
        _ = self.persistentStorage.createPhoto(photo: photo)
        
    }
    
    // MARK: - Other.
    func getLoggedUser() -> Promise<UserModel>{
        return self.persistentStorage.getLoggedUser()
    }
    
    func setLoggedUser(selectedUser: UserModel){
        self.persistentStorage.setLoggedUser(user: selectedUser)
    }
    
    func readTODOs(from userId: Int) -> Promise<[ToDoModel]> {
        if self.onlineConnection {
            return Promise { seal in
                self.apiManager.readTODOs(from: userId).done { (todos: [ToDoModel]) in
                    _ = self.persistentStorage.setTODOsList(elems: todos)
                    seal.fulfill(todos)
                }.catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        }
        return self.persistentStorage.readTODOs(from: userId)
    }
    
    func readAlbums(from userId: Int) -> Promise<[AlbumModel]> {
        if self.onlineConnection {
            return Promise { seal in
                self.apiManager.readAlbums(from: userId).done({ (albums: [AlbumModel]) in
                    _ = self.persistentStorage.appendAlbumsList(elems: albums)
                    seal.fulfill(albums)
                }).catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        }
        return self.persistentStorage.readAlbums(from: userId)
    }
    
    func readPhotos(from albumId: Int) -> Promise<[PhotoModel]> {
        if self.onlineConnection {
            return Promise { seal in
                self.apiManager.readPhotos(from: albumId).done({ (photos: [PhotoModel]) in
                    _ = self.persistentStorage.appendPhotosList(elems: photos)
                    seal.fulfill(photos)
                }) .catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        }
        return self.persistentStorage.readPhotos(fromAlbum: albumId)
    }
    
    func readPhotos(fromUser userId: Int) -> Promise <[PhotoModel]> {
        if self.onlineConnection {
            return Promise { seal in
                self.apiManager.readPhotos(fromUser: userId).done({ (photos: [PhotoModel]) in
                    _ = self.persistentStorage.appendPhotosList(elems: photos)
                    seal.fulfill(photos)
                }).catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        } else {
            return self.persistentStorage.readPhotos(from: userId)
        }
    }
    
    func readAllComments() -> Promise<[CommentModel]> {
        return Promise { resolve in
            self.apiManager.readAllComments().done({ (comments: [CommentModel]) in
                _ = self.persistentStorage.setCommentsList(elems: comments)
                resolve.fulfill(comments)
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func readAllPosts() -> Promise<[PostModel]> {
        return Promise { resolve in
            self.apiManager.readAllPosts().done({ (posts: [PostModel]) in
                _ = self.persistentStorage.setPostsList(elems: posts)
                resolve.fulfill(posts)
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func readPosts(from userId: Int) -> Promise<[PostModel]> {
        return self.persistentStorage.readPosts(from: userId)
    }
    
    func readComemnts(from userId: Int) -> Promise<[CommentModel]> {
        return self.persistentStorage.readComments(from: userId)
    }
    
    func getUIImage(from photo: PhotoModel) -> Promise<UIImage> {
        return Promise { resolve in
            self.persistentStorage.hasPhoto(photo: photo).done({ (hasUIImg: Bool) in
                if hasUIImg {
                    self.persistentStorage.getPhoto(photo: photo).done({ (result: UIImage) in
                        resolve.fulfill(result)
                    }).catch({ (error: Error) in
                        self.apiManager.fetchUIImage(photo: photo).done({ (image: UIImage) in
                            self.persistentStorage.savePhoto(photo: photo, uiImage: image, uiImageThumbnail: image)
                            resolve.fulfill(image)
                        }).catch({ (error: Error) in
                            resolve.reject(error)
                        })
                    })
                } else {
                    self.apiManager.fetchUIImage(photo: photo).done({ (image: UIImage) in
                        self.persistentStorage.savePhoto(photo: photo, uiImage: image, uiImageThumbnail: image)
                        resolve.fulfill(image)
                    }).catch({ (error: Error) in
                        resolve.reject(error)
                    })
                }
            }) .catch({ (error: Error) in
                self.apiManager.fetchUIImage(photo: photo).done({ (image: UIImage) in
                    self.persistentStorage.savePhoto(photo: photo, uiImage: image, uiImageThumbnail: image)
                    resolve.fulfill(image)
                }).catch({ (error: Error) in
                    resolve.reject(error)
                })
            })
        }
    }
    
    func saveToFavourites(photo:PhotoModel, uiImage: UIImage){
        
    }
    
    func getAllFavourites(){
        
    }
    
    /* ************************************* */
    /* *** */ // TESTING FUNCTIONS // /* *** */
    /* ************************************* */
    
    func testPersistentData( users: [UserModel] ) -> Promise<[UserModel]>{
        return Promise { resolve in
            self.persistentStorage.setUserList(users: users).done (on: DispatchQueue.init(label: "persistentStorage"), flags: nil) { (result : Bool) in
                    if result {
                        self.persistentStorage.readAllUsers().done (on: DispatchQueue.init(label: "persistentStorage"), flags: nil) { (usersResult: [UserModel]) in
                            resolve.fulfill(usersResult)
                            } .catch({ (error: Error) in
                                resolve.reject(error)
                            })
                    } else {
                        resolve.reject(NSError(domain: "Erorr with saving the data :D", code: 167616, userInfo: nil))
                    }
                } .catch({ (error:Error) in
                    resolve.reject(error)
                })
        }
    }
    
    func testPersistentData2(){
        let user1 = UserModel(id: 21, name: "Tom Brewer", username: "tomas_beer", email: "mail@mail.com", phone: "222333", website: "jahoo.com", address: UserAddress(street: "street", suite: "suite", city: "city", zipcode: "zipcode"), company: UserCompany(name: "name", catchPhrase: "catchPhrase", bs: "bs"))
        let user2 = UserModel(id: 22, name: "Tom Brewer", username: "tomas_beer", email: "mail@mail.com", phone: "222333", website: "jahoo.com", address: UserAddress(street: "street", suite: "suite", city: "city", zipcode: "zipcode"), company: UserCompany(name: "name", catchPhrase: "catchPhrase", bs: "bs"))
        
        self.persistentStorage.addUser(user: user1).done { (result: Bool) in
            if(result){
                print("user1 added")
                
                self.persistentStorage.readUser(userID: user1.id).done({ (result: UserModel) in
                    print(result)
                    print("Reading user success")
                    self.persistentStorage.deleteUser(userId: user1.id).done({ (result: Bool) in
                        print("Deleting user \(result)")
                        self.persistentStorage.readAllUsers().done({ (result:[UserModel]) in
                            result.forEach({ (user: UserModel) in
                                print(user.id ?? "-1")
                            })
                        }) .catch({ (error: Error) in
                            print(error)
                        })
                    }).catch({ (error: Error) in
                        print("Failed!")
                        print(error)
                    })
                }).catch({ (error: Error) in
                    print(error)
                })
                
            } else {
                print("Adding user1 failed")
            }
            
            self.persistentStorage.deleteUser(userId: user2.id).done({ (result: Bool) in
                if result {
                    print("This shouldn't happen")
                } else {
                    print("Delete failed :D")
                
                    self.persistentStorage.readUser(userID: user2.id).done({ (result: UserModel) in
                        print("Found user???")
                        print(result)
                    }).catch({ (error:Error) in
                        print(error)
                    })
                }
            }).catch({ (error: Error) in
                print(error)
            })
        }.catch { (error: Error) in
                print(error)
            } .finally {
                print("working on the second user?")
                self.persistentStorage.addUser(user: user2).done({ (result: Bool) in
                    if (result){
                        self.persistentStorage.readAllUsers().done({ (result: [UserModel]) in
                            result.forEach({ (user: UserModel) in
                                print(user.id!)
                            })
                        }).catch({ (error:Error) in
                            print(error)
                        })
                    } else {
                        print("We have a problem saving user2")
                    }
                }).catch({ (error: Error) in
                    print(error)
                })
        }
    }
    
}
