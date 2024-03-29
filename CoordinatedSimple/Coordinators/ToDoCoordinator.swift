//
//  ToDoCoordinator.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class ToDoCoordinator:NSObject, Coordinator {

    /* ********** */
    // Properties //
    /* ********** */
    public lazy var dataProvider = { () -> DataProvider in
        if let parent = self.parentCoordinator {
            return parent.getDataProvider()
        } else {
            return DataProvider()
        }
    }()
    
    weak var parentCoordinator: MainCoordinator?

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
        let vc = ToDoViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
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
    
    func getDataProvider() -> DataProvider {
        return self.dataProvider
    }


    /* ******************** */
    // Transition Functions //
    /* ******************** */
    
    
    
    /* ************************ */
    // Call from viewController //
    /* ************************ */
    func getLoggedUserToDo() -> Promise<[ToDoModel]> {
        return Promise { resolve in
            self.dataProvider.getLoggedUser().done({ (user: UserModel) in
                self.dataProvider.readTODOs(from: user.id).done({ (result: [ToDoModel]) in
                    resolve.fulfill(result)
                }).catch({ (error:Error) in
                    resolve.reject(error)
                })
            }).catch({ (error: Error) in
                resolve.reject(error)
            })
        }
    }
    
    
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
