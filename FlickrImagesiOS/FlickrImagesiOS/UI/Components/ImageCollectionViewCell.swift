//
//  ImageCollectionViewCell.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!

    func loadImage(url: URL){
        var options : KingfisherOptionsInfo = [.transition(.fade(0.2))]
        options.append(.processor(OverlayImageProcessor(overlay: .black, fraction: 0.5)))
        self.image.kf.setImage(with: url, options: options)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.kf.cancelDownloadTask()
        self.image.image = nil
    }
}
