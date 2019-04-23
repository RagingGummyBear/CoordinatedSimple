//
//  MainCoordinator.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class MainCoordinator:NSObject, Coordinator {

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
    weak var viewController: MainMenuViewController!

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController


    /* ************* */
    // Initalization //
    /* ************* */
    init(navigationController: UINavigationController) {
        PromiseKit.conf.Q.map = .global()
        PromiseKit.conf.Q.return = .main  //NOTE this is the default
        
        self.navigationController = navigationController
    }

    /* *********************************** */
    // Coordinator Protocol Implementation //
    /* *********************************** */
    func start(){
        self.navigationController.delegate = self // This line is a must do not remove
        self.viewController = MainMenuViewController.instantiate()
        self.viewController.coordinator = self
        navigationController.pushViewController(self.viewController, animated: true)
        
        self.dataProvider.getLoggedUser().done { (result: UserModel) in
            self.viewController.setLoggedUser(user: result)
        }.catch { (error: Error) in
            print(error)
        }
    }

    func childPop(_ child: Coordinator?){
        self.navigationController.delegate = self // This line is a must do not remove
        
        // Do coordinator parsing //
        if (child as? UsersDataCoordinator) != nil {
            self.dataProvider.getLoggedUser().done { (user: UserModel) in
                self.viewController.setLoggedUser(user: user)
                }.catch { (error: Error) in
                    // I really dont care about this :D
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
    
    func getDataProvider() -> DataProvider {
        return self.dataProvider
    }

    /* **************************************** */
    /* **************************************** */

    /* ******************** */
    // Transition Functions //
    /* ******************** */
    
    func displayToDoList(){
         let child = ToDoCoordinator(navigationController: navigationController)
         child.parentCoordinator = self
         childCoordinators.append(child)
         child.start()
    }

    func displayUsersData(){
        let child = UsersDataCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func displayUserAlbums(){
        let child = AlbumDisplayCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
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
