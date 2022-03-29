//
//  RetriveFavouriteService.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 29/03/22.
//

import Foundation
import CoreData

protocol RetriveFavouriteService {
    func retriveFavouritePOTD(completion: @escaping ([POTDFavorite]) -> Void)
}

struct RetriveFavouriteServiceImpl: RetriveFavouriteService {
    func retriveFavouritePOTD(completion: @escaping ([POTDFavorite]) -> Void) {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(POTDFavorite.fetchRequest()) as? [POTDFavorite] else {return}
            completion(result)
        } catch let error {
            debugPrint(error)
        }
    }
}
