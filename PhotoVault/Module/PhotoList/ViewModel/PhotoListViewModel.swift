//
//  PhotoListViewModel.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 26/02/26.
//

import Foundation
import Combine
import UIKit
import CoreData

class PhotoListViewModel {
    @Published var alertMessage: String?
    @Published var showActions: [UIAlertAction] = []
    @Published var viperOutput: [PhotoListOutputResponse]?
    @Published var allPhotos: [Photo] = []
    var cancellables = Set<AnyCancellable>()
    var vc: UIViewController?
    private let batchSize = 30
     var currentIndex = 0

    func callExampleAPI() {
        vc?.showActivityIndicator()
        PhotoListNetworkLayer.shared.callExampleAPI()
            .sink { completion in
                if case .failure(let error) = completion {
                    self.alertMessage = "Error: \(error.localizedDescription)"
                }
            } receiveValue: { response in
                self.vc?.hideActivityIndicator()
                self.viperOutput = response
                if let viperOutput = self.viperOutput, viperOutput.count > 0 {
                    CoreDataHelper.shared.savePhotos(viperOutput)
                    self.allPhotos = CoreDataHelper.shared.fetchPhotos(offset: self.currentIndex, limit: self.batchSize)
                    self.alertMessage = "API call successful"
                }

            }
            .store(in: &cancellables)
    }
    
    // MARK: - Core Data
    private func isCoreDataEmpty() -> Bool {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let count = try CoreDataHelper.shared.context.count(for: request)
            return count == 0
        } catch {
            alertMessage = "Core Data count error: \(error.localizedDescription)"
            return true
        }
    }
    func loadData() {
        currentIndex = 0
        
        if isCoreDataEmpty() {
            logToFile(" Core Data Empty, calling API")
            callExampleAPI()
        } else {
            logToFile(" Core Data Not Empty")
            allPhotos = CoreDataHelper.shared.fetchPhotos(offset: currentIndex, limit: batchSize)
        }
    }
    
    func addNextPage() {
        logToFile("CurrentIndex: \(currentIndex)")
        allPhotos += CoreDataHelper.shared.fetchPhotos(offset: currentIndex, limit: batchSize)
    }

    func deletePhoto(photo: Photo) {
        if let index = allPhotos.firstIndex(of: photo) {
            allPhotos.remove(at: index)
        }
        CoreDataHelper.shared.deletePhoto(photo)
    }
    
    
    func resetData() {
        do {
            try CoreDataHelper.shared.deleteAllPhotos()
            allPhotos.removeAll()
            loadData()
        } catch {
            alertMessage = "Failed to delete all photos: \(error.localizedDescription)"
        }
    }
    
}
