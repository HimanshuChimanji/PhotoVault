//
//  PhotoListInputRequest.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 26/02/26.
//

import Foundation

class PhotoListInputRequest: NetworkService <[PhotoListOutputResponse]> {
    private let endPoint: String = ApiConfig.Photos
    
    init() {
        super.init(baseURL: ApiConfig.BASEURL)
        self.request = Request(path: endPoint, method: .GET)
        
    }
}
