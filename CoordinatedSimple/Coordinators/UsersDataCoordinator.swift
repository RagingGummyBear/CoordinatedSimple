//
//  UsersDataCoordinator.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/19/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class UsersDataCoordinator:NSObject, Coordinator {

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

    weak var parentCoordinator: MainCoordinator?
    weak var viewController: UsersDataViewController!

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
        self.viewController = UsersDataViewController.instantiate()
        self.viewController.coordinator = self
        self.navigationController.pushViewController(self.viewController, animated: true)
    }

    func childPop(_ child: Coordinator?){
        self.navigationController.delegate = self // This line is a must do not remove

        // ////////////////////// //
        // Do coordinator parsing //
        if let coordinator = child as? SelectLoggedUserCoordinator {
            if coordinator.pickedNewUser {
                self.navigationController.popViewController(animated: true)
            }
        }
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
    
    // MARK: - Other functions
    public func requestAllUsers() -> Promise<[UserModel]>{
        return self.dataProvider.readAllUsers()
    }

    /* **************************************** */
    /* **************************************** */

    /* ******************** */
    // Transition Functions //
    /* ******************** */
    
     func displaySelectedUser(selectedUser: UserModel) {
         let child = SelectLoggedUserCoordinator(navigationController: navigationController)
         child.parentCoordinator = self
         childCoordinators.append(child)
        child.start(selectedUser: selectedUser)
     }

    /* **************************************** */
    // Examples // Remove them after inspecting //
    // func buySubscription() {
    //     let child = BuyCoordinator(navigationController: navigationController)
    //     child.parentCoordinator = self
    //     childCoordinators.append(child)
    //     child.start()
    // }
    //
    // func buySubscription(to productType: Int) {
    //     let child = BuyCoordinator(navigationController: navigationController)
    //     child.parentCoordinator = self
    //     childCoordinators.append(child)
    //     child.start(to: productType)
    // }
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
