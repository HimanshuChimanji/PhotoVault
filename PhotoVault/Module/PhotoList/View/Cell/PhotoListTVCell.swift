//
//  PhotoListTVCell.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 26/02/26.
//

import UIKit
import SDWebImage
class PhotoListTVCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with photo: Photo) {
        photoView.layer.cornerRadius = 8
        photoView.clipsToBounds = true
        photoView.layer.borderColor = UIColor.lightGray.cgColor
        photoView.layer.borderWidth = 1
        
        photoTitleLbl.text = photo.title
        
        
        if let url = URL(string: photo.thumbnailUrl ?? "") {
            photoImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "placeHolderImage"))
        } else {
            photoImageView.image = UIImage(named: "placeHolderImage")
        }
        
        photoImageView.layer.cornerRadius = 5
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleToFill

    }
    
}
