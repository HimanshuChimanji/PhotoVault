//
//  Photo+CoreDataProperties.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 26/02/26.
//
//

public import Foundation
public import CoreData


public typealias PhotoCoreDataPropertiesSet = NSSet

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var id: Int64
    @NSManaged public var albumId: Int64
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var thumbnailUrl: String?

}

extension Photo : Identifiable {

}
