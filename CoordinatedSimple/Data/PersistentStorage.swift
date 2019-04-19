//
//  PersistentStorage.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import PromiseKit

class PersistentStorage {
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    // User CRUD
    func readAllUsers() -> Promise<[UserModel]>{
        return Promise { resolve in
            do {
                    let data = try Data(contentsOf: self.getUsersDataUrl().appendingPathComponent("usersModelArray.usermodel"))
                    do {
                        let products = try JSONDecoder().decode([UserModel].self, from: data)
                        resolve.fulfill(products)
                    } catch let error {
                        resolve.reject(error)
                    }
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    func readUser(userID: Int) -> Promise<UserModel> {
        return Promise { resolve in
            self.readAllUsers().done({ (result: [UserModel]) in
                for user in result {
                    if user.id == userID {
                        resolve.fulfill(user)
                        return
                    }
                }
                resolve.reject(NSError(domain: "No user with id: \(userID) found", code: 489093, userInfo: nil))
            }) .catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func deleteUser(userId: Int) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllUsers().done({ (users: [UserModel]) in
                var userRemoved = false
                var newUserList = users
                newUserList.removeAll(where: { (user: UserModel) -> Bool in
                    if user.id == userId {
                        userRemoved = true
                    }
                    return user.id == userId
                })
                if userRemoved{
                    self.setUserList(users: newUserList).done({ (result: Bool) in
                        resolve.fulfill(result)
                    }).catch({ (error:Error) in
                        resolve.reject(error)
                    })
                }
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func addUser(user: UserModel) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllUsers().done({ (result: [UserModel]) in
                var newUsersList = result
                newUsersList.append(user)
                self.setUserList(users: newUsersList).done({ (result: Bool) in
                    resolve.fulfill(result)
                }).catch({ (error: Error) in
                    resolve.reject(error)
                })
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func setUserList( users: [UserModel]) -> Promise<Bool> {
        return Promise { resolve in
            do {
                let archiveData = try JSONEncoder().encode(users)
                try archiveData.write(to: self.getUsersDataUrl().appendingPathComponent("usersModelArray.usermodel"))
                resolve.fulfill(true)
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    func getUsersDataUrl() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let documentsDirectoryURL = path.appendingPathComponent("usersData")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            FileManager.default.createFile(atPath: documentsDirectoryURL.appendingPathComponent("usersModelArray.usermodel").path, contents: nil, attributes: nil)
        }
        return documentsDirectoryURL
    }
    
}
