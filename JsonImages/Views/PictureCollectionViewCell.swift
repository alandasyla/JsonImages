//
//  PictureCollectionViewCell.swift
//  JsonImages
//
//  Created by Alanda Syla on 11/5/17.
//  Copyright © 2017 Alanda Syla. All rights reserved.
//

import UIKit
import Kingfisher

class PictureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: ImageModel! {
        didSet {
            setupValues()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupValues() {
        DispatchQueue.main.async {
            self.imageView.kf.setImage(with: self.image.imageURL)
        }
    }
}

