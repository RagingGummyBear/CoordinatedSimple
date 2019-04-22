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

public class DataProvider {
    
    // MARK: - Properties
    let persistentStorage:PersistentStorage = KeyedArchiverHandler()
    let apiManager: APIManager = APIManager()
    
    
    // MARK: - Users => CRUD
    func readAllUsers() -> Promise<[UserModel]>{
        return self.apiManager.getAllUsers()
    }
    
    func readUser(userID: Int) -> Promise<UserModel> {
        return self.apiManager.readUser(userID: userID)
    }
    
    func updateUser(user: UserModel){
        // patch
    }
    
    func deleteUser(userId: Int){
        // delete
    }
    
    func createUser(user: UserModel){
        // put
    }
    
    
    // MARK: - TODOs => CRUD
    func readAllTODOs() -> Promise<[ToDoModel]>{
        return self.apiManager.realAllTODOs()
    }
    
    func readTODO(todoId: Int) -> Promise<ToDoModel> {
        return self.apiManager.readTODO(todoId: todoId)
    }
    
    func updateTODO(todo: ToDoModel){
        // patch
    }
    
    func deleteTODO(todoId: Int){
        // delete
    }
    
    func createTODO(todo: UserModel){
        // put
    }
    
    // MARK: - Albums => CRUD
    func readAllAlbums() {
    }
    
    func readAlbum(albumId: Int){
        
    }
    
    func updateAlbum(album: AlbumModel){
        // patch
    }
    
    func deleteAlbum(albumId: Int){
        // delete
    }
    
    func createAlbum(album: UserModel){
        // put
    }
    
    
    // MARK: - Photos => CRUD
    func readAllPhotos() -> Promise<[PhotoModel]> {
        return  Promise { resolve in
            
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
    
    func createPhoto(photo: PhotoModel) -> Promise<PhotoModel> {
        return  Promise { resolve in
            
        }
    }
    
    
    // MARK: - Other.
    func getLoggedUser() -> Promise<UserModel>{
        return self.persistentStorage.getLoggedUser()
    }
    
    func setLoggedUser(selectedUser: UserModel){
        self.persistentStorage.setLoggedUser(user: selectedUser)
    }
    
    func readTODOs(from userId: Int) -> Promise<[ToDoModel]> {
        return self.apiManager.readTODOs(from: userId)
    }
    
    func readAlbums(from userId: Int) -> Promise<[AlbumModel]> {
        return self.apiManager.readAlbums(from: userId)
    }
    
    func readPhotos(from albumId: Int) -> Promise<[PhotoModel]> {
        return self.apiManager.readPhotos(from: albumId)
    }
    
    func getUIImage(from photo: PhotoModel) -> Promise<UIImage> {
        return self.apiManager.fetchUIImage(photo: photo)
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
                                print(user.id)
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
