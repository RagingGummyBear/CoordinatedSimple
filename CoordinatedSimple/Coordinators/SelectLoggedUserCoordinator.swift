//
//  SelectLoggedUserCoordinator.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class SelectLoggedUserCoordinator:NSObject, Coordinator {

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

    weak var parentCoordinator: UsersDataCoordinator?
    weak var viewController: SelectLoggedUserViewController!

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var selectedUser: UserModel?
    public var pickedNewUser = false


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
        self.viewController = SelectLoggedUserViewController.instantiate()
        self.viewController.coordinator = self
        self.navigationController.pushViewController(self.viewController, animated: true)
        
    }
    
    func start(selectedUser: UserModel){
        self.navigationController.delegate = self // This line is a must do not remove
        self.viewController = SelectLoggedUserViewController.instantiate()
        self.viewController.coordinator = self
        self.navigationController.pushViewController(self.viewController, animated: true)
        self.selectedUser = selectedUser
    }

    func childPop(_ child: Coordinator?){
        self.navigationController.delegate = self // This line is a must do not remove
        /* ********************** */
        // Do coordinator parsing //
        /* ********************** */

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
    
    /* ******************** */
    // Additional functions //
    /* ******************** */
    func requestSelectedUser() -> Promise<UserModel> {
        return Promise { resolve in
            if let selected = self.selectedUser {
                resolve.fulfill(selected)
            } else {
                resolve.reject(NSError(domain: "No selected user", code: 404, userInfo: nil))
            }
        }
    }
    
    func setLoggedUser(){
        if let user = self.selectedUser {
            self.pickedNewUser = true
            self.dataProvider.setLoggedUser(selectedUser: user)
            self.navigationController.popViewController(animated: true)
        }
    }
    /* **************************************** */
    /* **************************************** */

    
    /* ******************** */
    // Transition Functions //
    /* ******************** */

    
    /* **************************************** */
    /* **************************************** */

    
    
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
