//
//  POTDFavorite+CoreDataProperties.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 29/03/22.
//
//

import Foundation
import CoreData


extension POTDFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<POTDFavorite> {
        return NSFetchRequest<POTDFavorite>(entityName: "POTDFavorite")
    }

    @NSManaged public var date: String?
    @NSManaged public var title: String?
    @NSManaged public var explanation: String?
    @NSManaged public var mediaURL: String?

}

extension POTDFavorite : Identifiable {

}
