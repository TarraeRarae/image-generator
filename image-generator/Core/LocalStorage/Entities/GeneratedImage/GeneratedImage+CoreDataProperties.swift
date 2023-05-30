//
//  GeneratedImage+CoreDataProperties.swift
//  image-generator
//
//  Created by Alexey Zubkov on 30.05.2023.
//
//

import Foundation
import CoreData

extension GeneratedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeneratedImage> {
        return NSFetchRequest<GeneratedImage>(entityName: "GeneratedImage")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var requestBaseURL: String?
}
