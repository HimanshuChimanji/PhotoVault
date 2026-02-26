//
//  CoreDataHelper.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 26/02/26.
//

import Foundation
import CoreData

final class CoreDataHelper {
    
    // MARK: - Singleton
    static let shared = CoreDataHelper()
    
    private init() {}
    
    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PhotoVault") // <-- Your .xcdatamodeld name
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("❌ Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // MARK: - Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

extension CoreDataHelper {
    
    func saveContext() {
        let context = context
        
        if context.hasChanges {
            do {
                try context.save()
                logToFile("Data Saved")
            } catch {
                print("❌ Core Data Save Error:", error.localizedDescription)
            }
        }
    }
}

extension CoreDataHelper {
    
    func savePhotos(_ photos: [PhotoListOutputResponse]) {
        
        for photo in photos {
            
            // Check duplicate
            if !isPhotoExists(id: photo.id ?? 0) {
                
                let entity = Photo(context: context)
                entity.id = Int64(photo.id ?? 0)
                entity.albumId = Int64(photo.albumId ?? 0)
                entity.title = photo.title
                entity.url = photo.url
                entity.thumbnailUrl = photo.thumbnailUrl
            }
        }
        
        saveContext()
    }
}


extension CoreDataHelper {
    
    func batchInsertPhotos(_ photos: [PhotoListOutputResponse]) {
        
        guard !photos.isEmpty else { return }
        
        let context = persistentContainer.newBackgroundContext()
        
        context.perform {
            
            let objects: [[String: Any]] = photos.map { photo in
                return [
                    "id": Int64(photo.id ?? 0),
                    "albumId": Int64(photo.albumId ?? 0),
                    "title": photo.title ?? "",
                    "url": photo.url ?? "",
                    "thumbnailUrl": photo.thumbnailUrl ?? ""
                ]
            }
            
            let batchInsert = NSBatchInsertRequest(entityName: "Photo",
                                                   objects: objects)
            
            batchInsert.resultType = .objectIDs
            
            do {
                let result = try context.execute(batchInsert) as? NSBatchInsertResult
                
                if let objectIDs = result?.result as? [NSManagedObjectID] {
                    
                    let changes: [AnyHashable: Any] = [
                        NSInsertedObjectsKey: objectIDs
                    ]
                    
                    NSManagedObjectContext.mergeChanges(
                        fromRemoteContextSave: changes,
                        into: [self.context]
                    )
                }
                
                print("✅ Batch insert successful")
                
            } catch {
                print("❌ Batch Insert Error:", error.localizedDescription)
            }
        }
    }
}

extension CoreDataHelper {
    
    func isPhotoExists(id: Int) -> Bool {
        
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("❌ Duplicate check failed:", error)
            return false
        }
    }
}

extension CoreDataHelper {
    
    func fetchPhotos(offset: Int, limit: Int) -> [Photo] {
        
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = limit
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Fetch Error:", error.localizedDescription)
            return []
        }
    }
}

extension CoreDataHelper {
    
    func updatePhotoTitle(photo: Photo, newTitle: String) {
        photo.title = newTitle
        saveContext()
    }
}

extension CoreDataHelper {
    
    func deletePhoto(_ photo: Photo) {
        context.delete(photo)
        saveContext()
    }
    
    func deleteAllPhotos() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Photo.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try context.execute(deleteRequest)
        saveContext()
    }
}
