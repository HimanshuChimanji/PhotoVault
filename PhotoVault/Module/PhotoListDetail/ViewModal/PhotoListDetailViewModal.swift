//
//  PhotoListDetailViewModal.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 26/02/26.
//

import Foundation

class PhotoListDetailViewModal {
    
    func editPhoto(photo: Photo, newTitle: String) {
        CoreDataHelper.shared.updatePhotoTitle(photo: photo, newTitle: newTitle)
    }
    
}
