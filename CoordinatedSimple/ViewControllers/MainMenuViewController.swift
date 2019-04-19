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

    // MARK: - IBOutlets actions
    @IBAction func getToDoList(_ sender: Any) {
        self.coordinator?.displayToDoList()
    }
    @IBAction func getAllUsers(_ sender: Any) {
        self.coordinator?.displayUsersData()
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
    }

    // MARK: - Other functions
    // Remember keep the logic and processing in the coordinator
}
