//
//  Coordinator.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/18/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator: NSObject, UINavigationControllerDelegate {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func getDataProvider() -> DataProvider
    func childPop(_ child: Coordinator?)
}
