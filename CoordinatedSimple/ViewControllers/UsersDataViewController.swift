//
//  UsersDataViewController.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/19/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import UIKit
import PromiseKit

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
        self.tableView.delegate = self
        // Change label's text, etc.
    }

    func finalUISetup(){
        // Here do all the resizing and constraint calculations
        // In some cases apply the background gradient here
        self.coordinator?.requestAllUsers().done({ [unowned self] (result: [UserModel]) in
            self.usersDidLoad(result)
        }) .catch({ (error:Error) in
            print(error)
            self.navigationController?.popViewController(animated: true)
        })
    }

    // MARK: - Other functions
    // Remember keep the logic and processing in the coordinator
    
    func usersDidLoad(_ users: [UserModel]) {
        self.dataSource = TableViewDataSource.make(for: users)
        tableView.dataSource = dataSource
        self.tableView.reloadData()
    }
    
}

extension UsersDataViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.coordinator?.displaySelectedUser(selectedUser: self.dataSource.models[indexPath.row])
    }
}
