//
//  PhotoDisplayCoordinator.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class PhotoDisplayCoordinator:NSObject, Coordinator, UIImageCoordinatorProtocol {

    /* ********** */
    // Properties //
    /* ********** */
    lazy var dataProvider = { () -> DataProvider in
        if let parent = self.parentCoordinator {
            return parent.getDataProvider()
        } else {
            return DataProvider()
        }
    }()

    weak var parentCoordinator: AlbumDisplayCoordinator?
    weak var viewController: PhotoDisplayViewController!
    var selectedAlbum: AlbumModel?

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController


    /* ************* */
    // Initalization //
    /* ************* */
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    /* *********************************** */
    // Coordinator Protocol Implementation //
    /* *********************************** */
    func start(){
        self.navigationController.delegate = self // This line is a must do not remove
        self.viewController = PhotoDisplayViewController.instantiate()
        self.viewController.coordinator = self
        self.navigationController.pushViewController(self.viewController, animated: true)
    }
    
    func start(selectedAlbum:AlbumModel){
        self.selectedAlbum = selectedAlbum
        self.navigationController.delegate = self // This line is a must do not remove
        self.viewController = PhotoDisplayViewController.instantiate()
        self.viewController.coordinator = self
        self.navigationController.pushViewController(self.viewController, animated: true)
    }

    func childPop(_ child: Coordinator?){
        self.navigationController.delegate = self // This line is a must do not remove
        // ////////////////////// //
        // Do coordinator parsing //
        
        // ////////////////////// //

        // Default code used for removing of child coordinators // TODO: refactor it
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    internal func getDataProvider() -> DataProvider {
        return self.dataProvider
    }
    
    func requestPhotoData() -> Promise<[PhotoModel]> {
        return Promise { resolve in
            if let selectedAlbum = self.selectedAlbum {
                self.dataProvider.readPhotos(from: selectedAlbum.id).done({ (results: [PhotoModel]) in
                    resolve.fulfill(results)
                }) .catch({ (error: Error) in
                    resolve.reject(error)
                })
            } else {
                self.navigationController.popViewController(animated: true)
            }
        }
    }
    
    func getUIImage(photo: PhotoModel) -> Promise<UIImage> {
        // Request the image from the data proivder -> dataprovier checks if should fetch from storage or internet
        return self.dataProvider.getUIImage(from: photo)
    }

    /* ******************** */
    // Transition Functions //
    /* ******************** */

    
    /* ************************************************************* */
    // Saddly I don't know how to put this code into the protocol :( //
    /* ************************************************************* */

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let parent = self.parentCoordinator {
            parent.childPop(self)
        }
    }
}
