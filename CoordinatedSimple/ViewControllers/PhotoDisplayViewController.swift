//
//  PhotoDisplayViewController.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import UIKit

class PhotoDisplayViewController: UIViewController, Storyboarded, TableViewCellDoubleTapPhotoDelegate {

    

    // MARK: - Custom references and variables
    weak var coordinator: PhotoDisplayCoordinator? // Don't remove
    var dataSource: TableViewDataSource<PhotoModel>!
    var foundPhotos: [PhotoModel] = [PhotoModel]()
    
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
        if #available(iOS 10.0, *) {
            self.tableView.prefetchDataSource = self
        } else {
            // Fallback on earlier versions
        }
    }

    func finalUISetup(){
        // Here do all the resizing and constraint calculations
        // In some cases apply the background gradient here
        self.setUpTableView()
    }

    // MARK: - Other functions
    // Remember keep the logic and processing in the coordinator
    func setUpTableView(){
        let cellIdentifier = "photoDisplayCellIdentifier"
        self.tableView.register(UINib(nibName: "ImageDislayTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.coordinator?.requestPhotoData().done({ [unowned self] (photos: [PhotoModel]) in
            self.foundPhotos = photos
            self.dataSource = TableViewDataSource.make(for: photos, imageProvider: self.coordinator!, doubleTapDelegate: self, reuseIdentifier: cellIdentifier)
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }).catch({ (error: Error) in
            print(error)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func doubleTapOn(photo: PhotoModel, uiImage: UIImage) {
        print("Dont care yo")
    }
}


extension PhotoDisplayViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if self.foundPhotos.count > indexPath.row {
                DispatchQueue.global().async { [unowned self] in
                    // This adds the images to local storage so it's fast enough to prevent the table view flickering and/or delayed image load
                    _ = self.coordinator?.getUIImage(photo: self.foundPhotos[indexPath.row])
                }
            }
        }
    }
}
