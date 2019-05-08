//
//  PersistentStorage.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import PromiseKit

protocol PersistentStorage {
    
    // MARK: - Posts CRUD
    func readAllPosts() -> Promise<[PostModel]>
    func readPost (postId: Int) -> Promise<PostModel>
    func updatePost (post: PostModel) -> Promise<Bool>
    func deletePost (postId: Int) -> Promise<Bool>
    func createPost (post: PostModel) -> Promise<Bool>
    func readPosts (from userId: Int) -> Promise<[PostModel]>
    func setPostsList (elems: [PostModel]) -> Promise<Bool>
    func appendPostsList (elems: [PostModel]) -> Promise<Bool>
    
    // MARK: - Comments CRUD
    func readAllComments() -> Promise<[CommentModel]>
    func readComment (commentId: Int) -> Promise<CommentModel>
    func updateComment (comment: CommentModel) -> Promise<Bool>
    func deleteComment (commentId: Int) -> Promise<Bool>
    func createComment (comment: CommentModel) -> Promise<Bool>
    func readComments (from userId: Int) -> Promise<[CommentModel]>
    func setCommentsList (elems: [CommentModel]) -> Promise<Bool>
    func appendCommentsList (elems: [CommentModel]) -> Promise<Bool>
    
    // MARK: - Photos CRUD
    func readAllPhotos() -> Promise<[PhotoModel]>
    func readPhoto (photoId: Int) -> Promise<PhotoModel>
    func updatePhoto (photo: PhotoModel) -> Promise<Bool>
    func deletePhoto (photoId: Int) -> Promise<Bool>
    func createPhoto (photo: PhotoModel) -> Promise<Bool>
    func readPhotos (from userId: Int) -> Promise<[PhotoModel]>
    func readPhotos (fromAlbum albumId: Int) -> Promise<[PhotoModel]>
    func setPhotosList (elems: [PhotoModel]) -> Promise<Bool>
    func appendPhotosList (elems: [PhotoModel]) -> Promise<Bool>
    
    // MARK: - Albums CRUD
    func readAllAlbums() -> Promise<[AlbumModel]>
    func readAlbum (albumId: Int) -> Promise<AlbumModel>
    func updateAlbum (album: AlbumModel) -> Promise<Bool>
    func deleteAlbum (albumId: Int) -> Promise<Bool>
    func createAlbum (album: AlbumModel) -> Promise<Bool>
    func readAlbums (from userId: Int) -> Promise<[AlbumModel]>
    func setAlbumsList (elems: [AlbumModel]) -> Promise<Bool>
    func appendAlbumsList (elems: [AlbumModel]) -> Promise<Bool>
    
    // MARK: - TODOs CRUD
    func readAllTODOs() -> Promise<[ToDoModel]>
    func readTODO (todoId: Int) -> Promise<ToDoModel>
    func updateTODO (todo: ToDoModel) -> Promise<Bool>
    func deleteTODO (todoId: Int) -> Promise<Bool>
    func createTODO (todo: ToDoModel) -> Promise<Bool>
    func readTODOs (from userId: Int) -> Promise<[ToDoModel]>
    func setTODOsList (elems: [ToDoModel]) -> Promise<Bool>
    func appendTODOsList (elems: [ToDoModel]) -> Promise<Bool>
    
    // CRUD functions for User model
    func readAllUsers() -> Promise<[UserModel]>
    func readUser(userID: Int) -> Promise<UserModel>
    func deleteUser(userId: Int) -> Promise<Bool>
    func addUser(user: UserModel) -> Promise<Bool>
    func setUserList(users: [UserModel]) -> Promise<Bool>
    func setUsersList(elems: [UserModel]) -> Promise<Bool>
    func appendUsersList(elems: [UserModel]) -> Promise<Bool>
    
    // From where locally to get the logged users data
    func getLoggedUserDataUrl() -> URL
    
    // Functions for user login and logged data retrieve //
    func setLoggedUser(user: UserModel)
    func hasLoggedUser() -> Promise<Bool>
    func logoutCurrentUser()
    func getLoggedUser() -> Promise<UserModel>
    ///////////////////////////////////////////////////////
    
    // This is used for improved scrolling. We get the photo with prefetch and add it to the local storage and then load it when it is required. In case it doesnt download soon enough we redownloaded it and overwrite the previous part of the image.
    func hasPhoto(photo: PhotoModel) -> Promise<Bool>
    func savePhoto(photo: PhotoModel, uiImage: UIImage, uiImageThumbnail: UIImage)
    func getPhoto(photo: PhotoModel) -> Promise<UIImage>
    func getPhotoThumbnail(photo: PhotoModel) -> Promise<UIImage>
    
    // This is local url
    func getPhotoStartingDirectory(albumId: Int) -> URL
    
    // This is local url
    func getFavouritePhotoStartingDirectory() -> URL
    // This is not implemented!
    func saveToFavourites(photo:PhotoModel, uiImage:UIImage)
    ///////////////////////////////////////////////////
    
}
