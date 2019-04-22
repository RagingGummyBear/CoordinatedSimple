//
//  SelectLoggedUserViewController.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import UIKit

class SelectLoggedUserViewController: UIViewController, Storyboarded {

    // MARK: - Custom references and variables
    weak var coordinator: SelectLoggedUserCoordinator? // Don't remove

    // MARK: - IBOutlets references
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    // MARK: - IBOutlets actions
    @IBAction func setDefaultUserAction(_ sender: Any) {
        self.coordinator?.setLoggedUser()
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
        self.coordinator?.requestSelectedUser().done({ (user: UserModel) in
            self.userIDLabel.text = "\(user.id!)"
            self.userNameLabel.text = user.name
            self.userEmailLabel.text = user.email
            self.userUsernameLabel.text = user.username
        }).catch({ (error: Error) in
            self.navigationController?.popViewController(animated: true)
        })
    }

    // MARK: - Other functions
    // Remember keep the logic and processing in the coordinator
    func setSelectedUser(user: UserModel){
//        self.userIDLabel.text = "\(user.id ?? -1)"
        self.userNameLabel.text = user.name
        self.userEmailLabel.text = user.email
        self.userUsernameLabel.text = user.username
    }
}
