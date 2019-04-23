//
//  UsersListDataSource.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/19/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    
    var models: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        cellConfigurator(model, cell)
        return cell
    }
}

extension TableViewDataSource where Model == ExampleModel {
    static func make(for models: [ExampleModel],
                     reuseIdentifier: String = "userDataCell") -> TableViewDataSource {
        return TableViewDataSource(
            models: models,
            reuseIdentifier: reuseIdentifier
        ) { (model, cell) in
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.description
        }
    }
}


extension TableViewDataSource where Model == UserModel {
    static func make(for users: [UserModel],
                     reuseIdentifier: String = "userDataCell") -> TableViewDataSource {
        return TableViewDataSource(
            models: users,
            reuseIdentifier: reuseIdentifier
        ) { (user, cell) in
            cell.textLabel?.text = user.username
            cell.detailTextLabel?.text = user.name
        }
    }
}

extension TableViewDataSource where Model == ToDoModel {
    static func make(for todos: [ToDoModel],
                     reuseIdentifier: String = "TodoTableViewCellIdentifier") -> TableViewDataSource {
        return TableViewDataSource(
            models: todos,
            reuseIdentifier: reuseIdentifier
        ) { (todo, cell) in
            cell.textLabel?.text = todo.title
            cell.detailTextLabel?.text = "\(todo.completed!)"
        }
    }
}


extension TableViewDataSource where Model == AlbumModel {
    static func make(for albums: [AlbumModel],
                     reuseIdentifier: String = "albumDisplayCellIdentifier") -> TableViewDataSource {
        return TableViewDataSource(
            models: albums,
            reuseIdentifier: reuseIdentifier
        ) { (album, cell) in
            cell.textLabel?.text = album.title
            cell.detailTextLabel?.text = "\(album.id!)"
        }
    }
}

extension TableViewDataSource where Model == PhotoModel {
    
    static func make(for photos: [PhotoModel], imageProvider: UIImageCoordinatorProtocol, doubleTapDelegate: TableViewCellDoubleTapPhotoDelegate?,
                     reuseIdentifier: String = "photosDisplayCellIdentifier") -> TableViewDataSource {
        return TableViewDataSource(
            models: photos,
            reuseIdentifier: reuseIdentifier
        ) { (photo, cell) in
            if let cell = cell as? ImageDislayTableViewCell {
                cell.imageTitleLabel.text = photo.title
                imageProvider.getUIImage(photo: photo).done({ (image: UIImage) in
                    cell.imageDisplayView.image = image
                }).catch({ (error: Error) in
                    print(error)
                })
                cell.displayingPhoto = photo
            } else {
                cell.textLabel?.text = photo.title
                cell.detailTextLabel?.text = photo.url
            }
        }
    }
}
