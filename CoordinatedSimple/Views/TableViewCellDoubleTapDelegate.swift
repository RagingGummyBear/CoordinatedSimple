//
//  TableViewCellDoubleTapDelegate.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/23/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewCellDoubleTapPhotoDelegate: class {
    func doubleTapOn(photo:PhotoModel, uiImage: UIImage)
}
