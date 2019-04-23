//
//  ImageDislayTableViewCell.swift
//  CoordinatedSimple
//
//  Created by Seavus on 4/22/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import UIKit

class ImageDislayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageDisplayView: UIImageView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    public weak var displayingPhoto: PhotoModel?
    weak public var doubleTapDelegate: TableViewCellDoubleTapPhotoDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
    }
    
    @objc func doubleTapAction(){
        if let tapDelegate = self.doubleTapDelegate, let photo = self.displayingPhoto, let img = self.imageDisplayView.image {
//            tapDelegate.doubleTapOn(photo: photo, uiImage: img)
        }
    }
    
}
