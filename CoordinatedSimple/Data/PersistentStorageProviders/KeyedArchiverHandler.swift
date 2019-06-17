//
//  KeyedArchiverHandler.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import PromiseKit

class KeyedArchiverHandler: PersistentStorage {
    
    // MARK: - Posts CRUD
    func readAllPosts() -> Promise<[PostModel]> {
        return Promise { resolve in
            do {
                let data = try Data(contentsOf: self.getPostsDataUrl())
                do {
                    let products = try JSONDecoder().decode([PostModel].self, from: data)
                    resolve.fulfill(products)
                } catch let error {
                    resolve.reject(error)
                }
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    func readPost(postId: Int) -> Promise<PostModel> {
        return Promise { resolve in
            self.readAllPosts().done({ (result: [PostModel]) in
                for elem in result {
                    if elem.id == postId {
                        resolve.fulfill(elem)
                        return
                    }
                }
                resolve.reject(NSError(domain: "No PostModel with id: \(postId) found", code: 489093, userInfo: nil))
            }) .catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func readPosts(from userId: Int) -> Promise<[PostModel]> {
        return Promise { resolve in
            self.readAllPosts().done({ (posts: [PostModel]) in
                var newElemList = posts
                newElemList.removeAll(where: { (elem: PostModel) -> Bool in
                    return elem.userId != userId
                })
                resolve.fulfill(newElemList)
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func updatePost(post: PostModel) -> Promise<Bool> {
        return Promise { resolve in
            resolve.fulfill(false)
        }
    }
    
    func deletePost(postId: Int) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllPosts().done({ (posts: [PostModel]) in
                var elemRemoved = false
                var newElemList = posts
                newElemList.removeAll(where: { (elem: PostModel) -> Bool in
                    if elem.id == postId {
                        elemRemoved = true
                    }
                    return elem.id == postId
                })
                if elemRemoved {
                    self.setPostsList(elems: newElemList).done({ (result: Bool) in
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
    
    func createPost(post: PostModel) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllPosts().done({ (result: [PostModel]) in
                var newElemsList = result
                if !newElemsList.contains(where: { (temp: PostModel) -> Bool in
                    return temp.id == post.id
                }) {
                    newElemsList.append(post)
                }
                self.setPostsList(elems: newElemsList).done({ (result: Bool) in
                    resolve.fulfill(result)
                }).catch({ (error: Error) in
                    resolve.reject(error)
                })
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func setPostsList(elems: [PostModel]) -> Promise<Bool> {
        return Promise { resolve in
            do {
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: self.getPostsDataUrl())
                resolve.fulfill(true)
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    func appendPostsList (elems: [PostModel]) -> Promise<Bool>{
        return Promise { seal in
            self.readAllPosts().done({ (posts: [PostModel]) in
                var newArray = posts
                for elem in elems {
                    if !posts.contains(where: { (temp: PostModel) -> Bool in
                        return elem.id == temp.id
                    }) {
                        newArray.append(elem)
                    }
                }
                _ = self.setPostsList(elems: newArray)
                seal.fulfill(true)
            }).catch({ (error: Error) in
                seal.reject(error)
            })
        }
    }
    
    // MARK: - Comments CRUD
    func readAllComments() -> Promise<[CommentModel]> {
        return Promise { resolve in
            do {
                let data = try Data(contentsOf: self.getCommentsDataUrl())
                do {
                    let products = try JSONDecoder().decode([CommentModel].self, from: data)
                    resolve.fulfill(products)
                } catch let error {
                    resolve.reject(error)
                }
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    func readComment(commentId: Int) -> Promise<CommentModel> {
        return Promise { resolve in
            self.readAllComments().done({ (result: [CommentModel]) in
                for elem in result {
                    if elem.id == commentId {
                        resolve.fulfill(elem)
                        return
                    }
                }
                resolve.reject(NSError(domain: "No CommentModel with id: \(commentId) found", code: 489093, userInfo: nil))
            }) .catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func updateComment(comment: CommentModel) -> Promise<Bool> {
        return Promise { resolve in
            resolve.fulfill(false)
        }
    }
    
    func deleteComment(commentId: Int) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllComments().done({ (elems: [CommentModel]) in
                var elemRemoved = false
                var newElemList = elems
                newElemList.removeAll(where: { (elem: CommentModel) -> Bool in
                    if elem.id == commentId {
                        elemRemoved = true
                    }
                    return elem.id == commentId
                })
                if elemRemoved {
                    self.setCommentsList(elems: newElemList).done({ (result: Bool) in
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
    
    func createComment(comment: CommentModel) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllComments().done({ (result: [CommentModel]) in
                var newElemsList = result
                
                if !newElemsList.contains(where: { (tempComment: CommentModel) -> Bool in
                    return comment.id == tempComment.id
                }) {
                    newElemsList.append(comment)
                }
                
                self.setCommentsList(elems: newElemsList).done({ (result: Bool) in
                    resolve.fulfill(result)
                }).catch({ (error: Error) in
                    resolve.reject(error)
                })
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func readComments(from userId: Int) -> Promise<[CommentModel]> {
        return Promise { resolve in
            self.readAllComments().done({ (elems: [CommentModel]) in
                self.readPosts(from: userId).done({ (posts: [PostModel]) in
                    var newElemList = [CommentModel]()
                    for post in posts {
                        newElemList.append(contentsOf: elems.filter({ (comment : CommentModel) -> Bool in
                            return comment.postId == post.id
                        }))
                    }
                    resolve.fulfill(newElemList)
                }).catch({ (error: Error) in
                    resolve.reject(error)
                })

            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func setCommentsList(elems: [CommentModel]) -> Promise<Bool> {
        return Promise { resolve in
            do {
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: self.getCommentsDataUrl())
                resolve.fulfill(true)
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    
    func appendCommentsList (elems: [CommentModel]) -> Promise<Bool> {
        return Promise { seal in
            self.readAllComments().done({ (comments: [CommentModel]) in
                var newArray = comments
                for elem in elems {
                    if !comments.contains(where: { (temp: CommentModel) -> Bool in
                        return elem.id == temp.id
                    }) {
                        newArray.append(elem)
                    }
                }
                _ = self.setCommentsList(elems: newArray)
                seal.fulfill(true)
            }).catch({ (error: Error) in
                seal.reject(error)
            })
        }
    }
    
    
    // MARK: - Photos CRUD
    func readAllPhotos() -> Promise<[PhotoModel]> {
        return Promise { resolve in
            do {
                let data = try Data(contentsOf: self.getPhotosDataUrl())
                do {
                    let products = try JSONDecoder().decode([PhotoModel].self, from: data)
                    resolve.fulfill(products)
                } catch let error {
                    resolve.reject(error)
                }
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    func readPhoto(photoId: Int) -> Promise<PhotoModel> {
        return Promise { resolve in
            self.readAllPhotos().done({ (result: [PhotoModel]) in
                for elem in result {
                    if elem.id == photoId {
                        resolve.fulfill(elem)
                        return
                    }
                }
                resolve.reject(NSError(domain: "No PhotoModel with id: \(photoId) found", code: 489093, userInfo: nil))
            }) .catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func updatePhoto(photo: PhotoModel) -> Promise<Bool> {
        return Promise { resolve in
            resolve.fulfill(false)
        }
    }
    
    func deletePhoto(photoId: Int) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllPhotos().done({ (elems: [PhotoModel]) in
                var elemRemoved = false
                var newElemList = elems
                newElemList.removeAll(where: { (elem: PhotoModel) -> Bool in
                    if elem.id == photoId {
                        elemRemoved = true
                    }
                    return elem.id == photoId
                })
                if elemRemoved {
                    self.setPhotosList(elems: newElemList).done({ (result: Bool) in
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
    
    func createPhoto(photo: PhotoModel) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllPhotos().done({ (result: [PhotoModel]) in
                var newElemsList = result
                if !newElemsList.contains(where: { (tempPhoto: PhotoModel) -> Bool in
                    return photo.id == tempPhoto.id
                }) {
                    newElemsList.append(photo)
                }
                self.setPhotosList(elems: newElemsList).done({ (result: Bool) in
                    resolve.fulfill(result)
                }).catch({ (error: Error) in
                    resolve.reject(error)
                })
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func readPhotos(from userId: Int) -> Promise<[PhotoModel]> {
        return Promise { seal in
            self.readAlbums(from: userId).done({ (albums: [AlbumModel]) in
                self.readAllPhotos().done({ (photos: [PhotoModel]) in
                    var newElemsArray = photos
                    newElemsArray.removeAll(where: { (photo: PhotoModel) -> Bool in
                        return !albums.contains(where: { (album: AlbumModel) -> Bool in
                            return album.id == photo.albumId
                        })
                    })
                    seal.fulfill(newElemsArray)
                }).catch({ (error: Error) in
                    seal.reject(error)
                })
            }).catch({ (error: Error) in
                seal.reject(error)
            })
        }
    }
    
    func readPhotos(fromAlbum albumId: Int) -> Promise<[PhotoModel]> {
        return Promise { seal in
            self.readAllPhotos().done({ (photos: [PhotoModel]) in
                var newElemArray = photos
                newElemArray.removeAll(where: { (photo: PhotoModel) -> Bool in
                    return photo.albumId != albumId
                })
                seal.fulfill(newElemArray)
            }) .catch({ (error: Error) in
                seal.reject(error)
            })
        }
    }
    
    func setPhotosList(elems: [PhotoModel]) -> Promise<Bool> {
        return Promise { resolve in
            do {
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: self.getPhotosDataUrl())
                resolve.fulfill(true)
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    
    func appendPhotosList (elems: [PhotoModel]) -> Promise<Bool> {
        return Promise { seal in
            self.readAllPhotos().done({ (photos: [PhotoModel]) in
                var newArray = photos
                for elem in elems {
                    if !photos.contains(where: { (temp: PhotoModel) -> Bool in
                        return temp.id == elem.id
                    }) {
                        newArray.append(elem)
                    }
                }
                _ = self.setPhotosList(elems: newArray)
                seal.fulfill(true)
            }).catch({ (error:Error) in
                seal.reject(error)
            })
        }
    }
    
    // MARK: - Albums CRUD
    func readAllAlbums() -> Promise<[AlbumModel]> {
        return Promise { resolve in
            do {
                let data = try Data(contentsOf: self.getAlbumsDataUrl())
                do {
                    let products = try JSONDecoder().decode([AlbumModel].self, from: data)
                    resolve.fulfill(products)
                } catch let error {
                    resolve.reject(error)
                }
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    func readAlbum(albumId: Int) -> Promise<AlbumModel> {
        return Promise { resolve in
            self.readAllAlbums().done({ (result: [AlbumModel]) in
                for elem in result {
                    if elem.id == albumId {
                        resolve.fulfill(elem)
                        return
                    }
                }
                resolve.reject(NSError(domain: "No AlbumModel with id: \(albumId) found", code: 489093, userInfo: nil))
            }) .catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func updateAlbum(album: AlbumModel) -> Promise<Bool> {
        return Promise { resolve in
            resolve.fulfill(false)
        }
    }
    
    func deleteAlbum(albumId: Int) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllAlbums().done({ (elems: [AlbumModel]) in
                var elemRemoved = false
                var newElemList = elems
                newElemList.removeAll(where: { (elem: AlbumModel) -> Bool in
                    if elem.id == albumId {
                        elemRemoved = true
                    }
                    return elem.id == albumId
                })
                if elemRemoved {
                    self.setAlbumsList(elems: newElemList).done({ (result: Bool) in
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
    
    func createAlbum(album: AlbumModel) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllAlbums().done({ (result: [AlbumModel]) in
                var newElemsList = result
                if !newElemsList.contains(where: { (temp: AlbumModel) -> Bool in
                    return temp.id == album.id
                }) {
                    newElemsList.append(album)
                }
                self.setAlbumsList(elems: newElemsList).done({ (result: Bool) in
                    resolve.fulfill(result)
                }).catch({ (error: Error) in
                    resolve.reject(error)
                })
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func readAlbums(from userId: Int) -> Promise<[AlbumModel]> {
        return Promise { seal in
            self.readAllAlbums().done { (albums: [AlbumModel]) in
                print(albums)
                var newElemList = albums
                newElemList.removeAll(where: { (album: AlbumModel) -> Bool in
                    return album.userId != userId
                })
                seal.fulfill(newElemList)
            }.catch { (error: Error) in
                seal.reject(error)
            }
        }
    }
    
    func setAlbumsList(elems: [AlbumModel]) -> Promise<Bool> {
        return Promise { resolve in
            do {
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: self.getAlbumsDataUrl())
                resolve.fulfill(true)
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    func appendAlbumsList (elems: [AlbumModel]) -> Promise<Bool> {
        return Promise { seal in
            self.readAllAlbums().done({ (albums: [AlbumModel]) in
                var newArray = albums
                for elem in elems {
                    if !albums.contains(where: { (temp: AlbumModel) -> Bool in
                        return elem.id == temp.id
                    }) {
                        newArray.append(elem)
                    }
                }
                _ = self.setAlbumsList(elems: newArray)
                seal.fulfill(true)
            }).catch({ (error: Error) in
                seal.reject(error)
            })
        }
    }
    
    // MARK: - TODOs CRUD
    func readAllTODOs() -> Promise<[ToDoModel]> {
        return Promise { resolve in
            do {
                let data = try Data(contentsOf: self.getTODOsDataUrl())
                do {
                    let products = try JSONDecoder().decode([ToDoModel].self, from: data)
                    resolve.fulfill(products)
                } catch let error {
                    resolve.reject(error)
                }
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    func readTODO(todoId: Int) -> Promise<ToDoModel> {
        return Promise { resolve in
            self.readAllTODOs().done({ (result: [ToDoModel]) in
                for elem in result {
                    if elem.id == todoId {
                        resolve.fulfill(elem)
                        return
                    }
                }
                resolve.reject(NSError(domain: "No ToDoModel with id: \(todoId) found", code: 489093, userInfo: nil))
            }) .catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func updateTODO(todo: ToDoModel) -> Promise<Bool> {
        return Promise { resolve in
            resolve.fulfill(false)
        }
    }
    
    func deleteTODO(todoId: Int) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllTODOs().done({ (elems: [ToDoModel]) in
                var elemRemoved = false
                var newElemList = elems
                newElemList.removeAll(where: { (elem: ToDoModel) -> Bool in
                    if elem.id == todoId {
                        elemRemoved = true
                    }
                    return elem.id == todoId
                })
                if elemRemoved {
                    self.setTODOsList(elems: newElemList).done({ (result: Bool) in
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
    
    func createTODO(todo: ToDoModel) -> Promise<Bool> {
        return Promise { resolve in
            self.readAllTODOs().done({ (result: [ToDoModel]) in
                var newElemsList = result
                newElemsList.append(todo)
                self.setTODOsList(elems: newElemsList).done({ (result: Bool) in
                    resolve.fulfill(result)
                }).catch({ (error: Error) in
                    resolve.reject(error)
                })
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func readTODOs(from userId: Int) -> Promise<[ToDoModel]> {
        return Promise { resolve in
            self.readAllTODOs().done({ (elems: [ToDoModel]) in
                var newElemList = elems
                newElemList.removeAll(where: { (elem: ToDoModel) -> Bool in
                    return elem.userId != userId
                })
                resolve.fulfill(newElemList)
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    func setTODOsList(elems: [ToDoModel]) -> Promise<Bool> {
        return Promise { resolve in
            do {
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: self.getTODOsDataUrl())
                resolve.fulfill(true)
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    
    func appendTODOsList (elems: [ToDoModel]) -> Promise<Bool> {
        return Promise { seal in
            self.readAllTODOs().done({ (todos: [ToDoModel]) in
                var newArray = todos
                for elem in elems {
                    if !todos.contains(where: { (temp: ToDoModel) -> Bool in
                        return temp.id == elem.id
                    }) {
                        newArray.append(elem)
                    }
                }
                _ = self.setTODOsList(elems: newArray)
                seal.fulfill(true)
            }).catch({ (error: Error) in
                seal.reject(error)
            })
        }
    }
    
    // MARK: - Local data urls
    func getPostsDataUrl() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("postsData")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = path.appendingPathComponent("postsModelArray.postmodel")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            FileManager.default.createFile(atPath: documentsDirectoryURL.path, contents: nil, attributes: nil)
            
            do {
                let elems = [PostModel]()
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: documentsDirectoryURL)
            } catch let error {
                print(error)
            }
        }
        return documentsDirectoryURL
    }
    
    func getCommentsDataUrl() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("commentsData")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = path.appendingPathComponent("commentsModelArray.commentmodel")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            FileManager.default.createFile(atPath: documentsDirectoryURL.path, contents: nil, attributes: nil)
            
            do {
                let elems = [CommentModel]()
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: documentsDirectoryURL)
            } catch let error {
                print(error)
            }
        }
        
        return documentsDirectoryURL
    }
    
    func getPhotosDataUrl() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("photosData")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = path.appendingPathComponent("photosModelArray.photomodel")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            FileManager.default.createFile(atPath: documentsDirectoryURL.path, contents: nil, attributes: nil)
            
            do {
                let elems = [PhotoModel]()
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: documentsDirectoryURL)
            } catch let error {
                print(error)
            }
        }
        
        return documentsDirectoryURL
    }
    
    func getAlbumsDataUrl() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("albumsData")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = path.appendingPathComponent("albumsModelArray.albummodel")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            FileManager.default.createFile(atPath: documentsDirectoryURL.path, contents: nil, attributes: nil)
            
            do {
                let elems = [PostModel]()
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: documentsDirectoryURL)
            } catch let error {
                print(error)
            }
        }
        
        return documentsDirectoryURL
    }
    
    func getTODOsDataUrl() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("todosData")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = path.appendingPathComponent("todosModelArray.todomodel")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            FileManager.default.createFile(atPath: documentsDirectoryURL.path, contents: nil, attributes: nil)
            do {
                let elems = [ToDoModel]()
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: documentsDirectoryURL)
            } catch let error {
                print(error)
            }
        }
        
        return documentsDirectoryURL
    }
    
    
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    // MARK: - Users => CRUD
    func readAllUsers() -> Promise<[UserModel]>{
        return Promise { resolve in
            do {
                let data = try Data(contentsOf: self.getUsersDataUrl())
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
                try archiveData.write(to: self.getUsersDataUrl())
                resolve.fulfill(true)
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    func setUsersList(elems: [UserModel]) -> Promise<Bool> {
        return self.setUserList(users: elems)
    }
    
    func appendUsersList(elems: [UserModel]) -> Promise<Bool> {
        return Promise { seal in
            self.readAllUsers().done({ (users: [UserModel]) in
                var newArray = users
                for elem in elems {
                    if !newArray.contains(where: { (user: UserModel) -> Bool in
                        return user.id == elem.id
                    }) {
                        newArray.append(elem)
                    }
                }
                _ = self.setUsersList(elems: newArray)
                seal.fulfill(true)
            }) .catch({ (error: Error) in
                seal.reject(error)
            })
        }
    }
    
    func getUsersDataUrl() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("usersData")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = path.appendingPathComponent("usersModelArray.usermodel")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            FileManager.default.createFile(atPath: documentsDirectoryURL.path, contents: nil, attributes: nil)
            
            do {
                let array = [UserModel]()
                let archiveData = try JSONEncoder().encode(array)
                try archiveData.write(to: documentsDirectoryURL)
            } catch let error {
                print(error)
            }
        }
        
        return documentsDirectoryURL
    }
    
    // MARK: - USERS => Others.
    
    func getLoggedUserDataUrl() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("usersData")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent("loggedUserData.usermodel")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path){
            FileManager.default.createFile(atPath: documentsDirectoryURL.path, contents: nil, attributes: nil)
        }
        
        return documentsDirectoryURL
    }
    
    func setLoggedUser(user: UserModel){
        do {
            let archiveData = try JSONEncoder().encode(user)
            try archiveData.write(to: self.getLoggedUserDataUrl())
        } catch let err {
            // Handle error?
            print(err)
            self.logoutCurrentUser()
        }
    }
    
    func hasLoggedUser() -> Promise<Bool> {
        return Promise { resolve in
            
            do {
                let loggedUserUrl = self.getLoggedUserDataUrl()
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: loggedUserUrl.path)
                if let fileSize = fileAttributes[FileAttributeKey.size]  {
                    if (fileSize as! NSNumber).uint64Value > 0 {
                        resolve.fulfill(true)
                    }
                } else {
                    print("Failed to get a size attribute from path: \(loggedUserUrl.path)")
                    resolve.fulfill(false)
                }
            } catch let error {
                resolve.reject(error)
            }
            
        }
    }
    
    func logoutCurrentUser(){
        let loggedUserUrl = self.getLoggedUserDataUrl()
        let text = ""
        try? text.write(toFile: loggedUserUrl.path, atomically: false, encoding: String.Encoding.utf8)
    }
    
    func getLoggedUser() -> Promise<UserModel> {
        return Promise { resolve in
            do {
                let data = try Data(contentsOf: self.getLoggedUserDataUrl())
                do {
                    let user = try JSONDecoder().decode(UserModel.self, from: data)
                    resolve.fulfill(user)
                } catch let error {
                    resolve.reject(error)
                }
            } catch let err {
                resolve.reject(err)
            }
        }
    }
    
    // MARK: - UIImage functions
    func hasPhoto(photo: PhotoModel) -> Promise<Bool> {
        return Promise { resolve in
            var photoImageUrl = self.getPhotoStartingDirectory(albumId: photo.albumId)
            var photoThumbnailUrl = self.getPhotoStartingDirectory(albumId: photo.albumId)
            
            let strPhotoID = "\(photo.id!)"
            
            photoImageUrl = photoImageUrl.appendingPathComponent("photo\(strPhotoID).jepg")
            photoThumbnailUrl = photoThumbnailUrl.appendingPathComponent("thumbnail\(strPhotoID).jepg")
            
            resolve.fulfill(FileManager.default.fileExists(atPath: photoImageUrl.path) && FileManager.default.fileExists(atPath: photoThumbnailUrl.path))
        }
    }
    
    func savePhoto(photo: PhotoModel, uiImage: UIImage, uiImageThumbnail: UIImage) {
        var photoImageUrl = self.getPhotoStartingDirectory(albumId: photo.albumId)
        var photoThumbnailUrl = self.getPhotoStartingDirectory(albumId: photo.albumId)
        
        let strPhotoID = "\(photo.id!)"
        
        photoImageUrl = photoImageUrl.appendingPathComponent("photo\(strPhotoID).jepg")
        photoThumbnailUrl = photoThumbnailUrl.appendingPathComponent("thumbnail\(strPhotoID).jepg")
        
        let photoData = uiImage.jpegData(compressionQuality: 1.0)
        let thumbnailData = uiImageThumbnail.jpegData(compressionQuality: 1.0)
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: photoImageUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: photoImageUrl.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try photoData!.write(to: photoImageUrl)
        } catch let error {
            print("error saving file with error", error)
        }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: photoThumbnailUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: photoThumbnailUrl.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try thumbnailData!.write(to: photoThumbnailUrl)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func getPhoto(photo: PhotoModel) -> Promise<UIImage> {
        return Promise { resolve in
            var photoImageUrl = self.getPhotoStartingDirectory(albumId: photo.albumId)
            let strPhotoID = "\(photo.id!)"
            photoImageUrl = photoImageUrl.appendingPathComponent("photo\(strPhotoID).jepg")
            if let img = UIImage(contentsOfFile: photoImageUrl.path) {
                resolve.fulfill(img)
            } else {
                resolve.reject(NSError(domain: "No image", code: 404, userInfo: nil))
            }
        }
    }
    
    func getPhotoThumbnail(photo: PhotoModel) -> Promise<UIImage> {
        return Promise { resolve in
            var photoThumbnailUrl = self.getPhotoStartingDirectory(albumId: photo.albumId)
            let strPhotoID = "\(photo.id!)"
            photoThumbnailUrl = photoThumbnailUrl.appendingPathComponent("thumbnail\(strPhotoID).jepg")
            if let img = UIImage(contentsOfFile: photoThumbnailUrl.path) {
                resolve.fulfill(img)
            } else {
                resolve.reject(NSError(domain: "No thumbnail", code: 404, userInfo: nil))
            }
        }
    }
    
    func getPhotoStartingDirectory(albumId: Int) -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("photos")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent("albumid\(albumId).jepg")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path){
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        return documentsDirectoryURL
    }
    
    //
    
    func getFavouritePhotoStartingDirectory() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("photos")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent("favourites")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path){
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        return documentsDirectoryURL
    }
    
    func saveToFavourites(photo:PhotoModel, uiImage:UIImage){
        let photoUrl = self.getFavouritePhotoStartingDirectory().appendingPathComponent("\(photo.id!).jepg")
        if let imageData = uiImage.jpegData(compressionQuality: 1.0) {
            do {
                try imageData.write(to: photoUrl)
            } catch let error {
                print(error)
            }
        }
    }
    
}
