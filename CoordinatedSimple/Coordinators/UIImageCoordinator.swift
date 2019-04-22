//
//  UIImageCoordinator.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import PromiseKit

protocol UIImageCoordinatorProtocol {
    func getUIImage(photo: PhotoModel) -> Promise<UIImage>
}
