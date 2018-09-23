//
//  MovieCell.swift
//  TVBox
//
//  Created by Vitaly Berg on 23/09/2018.
//  Copyright © 2018 Vitaly Berg. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func fill(movie: Movie) {
        imageView.sd_setImage(with: movie.cover)
        titleLabel.text = movie.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class var nib: UINib {
        return UINib(nibName: "MovieCell", bundle: nil)
    }
}
