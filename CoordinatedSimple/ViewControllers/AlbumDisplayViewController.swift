//
//  AlbumDisplayViewController.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import UIKit

class AlbumDisplayViewController: UIViewController, Storyboarded {

    // MARK: - Custom references and variables
    weak var coordinator: AlbumDisplayCoordinator? // Don't remove
    var dataSource: TableViewDataSource<AlbumModel>!

    // MARK: - IBOutlets references
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBOutlets actions

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async { [unowned self] in
            self.initalUISetup()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async { [unowned self] in
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
        self.coordinator?.requestAlbumData().done({ [unowned self] (albums: [AlbumModel]) in
            self.tableView.delegate = self
            self.dataSource = TableViewDataSource.make(for: albums)
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

extension AlbumDisplayViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.coordinator?.displayAlbum(album: self.dataSource.models[indexPath.row])
    }
    
}


