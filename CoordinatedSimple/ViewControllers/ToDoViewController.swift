//
//  ToDoViewController.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController, Storyboarded {

    // MARK: - Custom references and variables
    weak var coordinator: ToDoCoordinator? // Don't remove
    var dataSource: TableViewDataSource<ToDoModel>!

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
        self.coordinator?.getLoggedUserToDo().done({ [unowned self] (result:[ToDoModel]) in
            self.dataSource = TableViewDataSource.make(for: result)
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }).catch({ (error: Error) in
            print(error)
            self.navigationController?.popViewController(animated: true)
        })
    }

    // MARK: - Other functions
    // Remember keep the logic and processing in the coordinator
}
