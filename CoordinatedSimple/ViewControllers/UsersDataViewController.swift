//
//  UsersDataViewController.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/19/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import UIKit

class UsersDataViewController: UIViewController, Storyboarded {

    // MARK: - Custom references and variables
    weak var coordinator: UsersDataCoordinator? // Don't remove
    var dataSource: TableViewDataSource<UserModel>!

    // MARK: - IBOutlets references
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBOutlets actions

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
    }

    // MARK: - Other functions
    // Remember keep the logic and processing in the coordinator
    
    func usersDidLoad(_ users: [UserModel]) {
        let dataSource = TableViewDataSource(
            models: users,
            reuseIdentifier: "userDataCell"
        ) { user, cell in
            cell.textLabel?.text = user.username
            cell.detailTextLabel?.text = user.name
        }
        
        // We also need to keep a strong reference to the data source,
        // since UITableView only uses a weak reference for it.
        self.dataSource = dataSource
        tableView.dataSource = dataSource
    }
}
