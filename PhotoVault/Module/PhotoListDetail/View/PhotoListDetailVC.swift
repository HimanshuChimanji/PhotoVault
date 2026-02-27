//
//  PhotoListDetailVC.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 26/02/26.
//

import UIKit
import SDWebImage

class PhotoListDetailVC: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var photoTextView: UITextView!
    
    var photo: Photo?
    let viewModel = PhotoListDetailViewModal()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.photoTextView.text = self.photo?.title
        self.photoTextView.layer.cornerRadius = 5
        self.photoTextView.clipsToBounds = true
        self.photoTextView.layer.borderWidth = 1
        self.photoTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.photoTextView.setPadding(top: 10, left: 10, bottom: 10, right: 10)
        
        if let url = URL(string: photo?.thumbnailUrl ?? "") {
            photoImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "placeHolderImage"))
        } else {
            photoImageView.image = UIImage(named: "placeHolderImage")
        }
        
        photoImageView.layer.cornerRadius = 5
        photoImageView.clipsToBounds = true

    }

    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func updateBtnAction(_ sender: UIButton) {
        guard let title = self.photoTextView.text, title.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            self.showAlert(title: "Error", message: "Please enter title")
            return
        }
        
        guard let photo = self.photo else {
            self.showAlert(title: "Error", message: "Something went wrong")
            return
        }
        self.showActivityIndicator()
        viewModel.editPhoto(photo: photo, newTitle: title)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            
            self.hideActivityIndicator()
            self.showAlert(title: "Success", message: "Photo Title updated successfully",actions: [okAction])
        }
        
    }
    

}
