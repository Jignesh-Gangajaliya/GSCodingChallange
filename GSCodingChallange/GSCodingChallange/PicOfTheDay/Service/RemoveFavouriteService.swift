//
//  RemoveFavouriteService.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 29/03/22.
//

import CoreData

protocol RemoveFavouriteService {
    func deleteFavouritePOTD(of date: String) -> POTDFavorite?
    func searchFavouritePOTD(of date: String) -> Bool
}

struct RemoveFavouriteServiceImpl: RemoveFavouriteService {
    func deleteFavouritePOTD(of date: String) -> POTDFavorite? {
        let fetchRequest = NSFetchRequest<POTDFavorite>(entityName: "POTDFavorite")
        let predicate = NSPredicate(format: "date==%@", date as String)
        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
            guard result != nil else {return nil}
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
    
    func searchFavouritePOTD(of date: String) -> Bool {
        let fetchRequest = NSFetchRequest<POTDFavorite>(entityName: "POTDFavorite")
        let predicate = NSPredicate(format: "date==%@", date as String)
        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
            guard result != nil else { return false }
            return true
        } catch let error {
            debugPrint(error)
        }
        return false
    }
}
