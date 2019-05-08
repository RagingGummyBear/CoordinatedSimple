//
//  MainMenuViewController.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, Storyboarded {

    // MARK: - Custom references and variables
    weak var coordinator: MainCoordinator? // Don't remove

    // MARK: - IBOutlets references
    @IBOutlet weak var loggedUserLabel: UILabel!
    @IBOutlet weak var debugImg: UIImageView!
    
    // MARK: - IBOutlets actions
    @IBAction func getToDoList(_ sender: Any) {
        self.coordinator?.displayToDoList()
    }
    @IBAction func getAllUsers(_ sender: Any) {
        self.coordinator?.displayUsersData()
    }
    @IBAction func displayUserAlbums(_ sender: Any) {
        self.coordinator?.displayUserAlbums()
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.initalUISetup()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async {
            self.finalUISetup()
        }
    }

    // MARK: - UI Functions
    func initalUISetup(){
        // Change label's text, etc.
    }

    func finalUISetup(){
        // Here do all the resizing and constraint calculations
        // In some cases apply the background gradient here
//        self.coordinator?.dataProvider.getUIImage(from: PhotoModel(albumId: 0, id: 1, title: "123", url: "https://via.placeholder.com/600/24f355", thumbnailUrl: "123")).done({ (result: UIImage) in
//            self.debugImg.image = result
//        })
        
//        self.coordinator?.dataProvider.readAllTODOs().done({ (ok : [ToDoModel]) in
////            print(ok)
//        })

//        self.coordinator?.getDataProvider().readAllAlbums().done({ (aAlbums: [AlbumModel]) in
//            self.coordinator?.getDataProvider().persistentStorage.readAllAlbums().done({ (localAlbums: [AlbumModel]) in
//                print(localAlbums)
//            }) .catch({ (error: Error) in
//                print(error)
//            })
//        })
        
//        self.coordinator?.getDataProvider().apiManager.readAllAlbums().done({ (aAlbums: [AlbumModel]) in
//            self.coordinator?.getDataProvider().getLoggedUser().done({ (user: UserModel) in
//                self.coordinator?.getDataProvider().persistentStorage.readAlbums(from: user.id).done({ (albums: [AlbumModel]) in
//                    print(albums)
//                }) .catch({ (error: Error) in
//                    print(error)
//                })
//            })
//        })

        
//        self.coordinator?.dataProvider.readAllComments().done({ (allComments: [CommentModel]) in
//            print("\n\n")
//            print(allComments)
//            self.coordinator?.dataProvider.readAllPosts().done({ (posts: [PostModel]) in
//
//                print("\n\n")
//                print(posts)
//                self.coordinator?.dataProvider.getLoggedUser().done({ (loggedUser: UserModel) in
//
//                    print("\n\n")
//                    print(loggedUser)
//                    self.coordinator?.dataProvider.readComemnts(from: loggedUser.id).done({ (uComments: [CommentModel]) in
//                        print("\n\n This is amazing :DD :D: \n\n")
//                        print(uComments)
//                    }) .catch({ (error: Error) in
//                        print(error)
//                    })
//                })
//            })
//        })
        
    }

    // MARK: - Other functions
    // Remember keep the logic and processing in the coordinator
    func setLoggedUser(user:UserModel){
        self.loggedUserLabel.text = user.username
    }
}
