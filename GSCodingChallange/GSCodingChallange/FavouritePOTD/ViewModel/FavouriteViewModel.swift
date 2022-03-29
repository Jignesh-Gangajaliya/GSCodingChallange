//
//  FavouriteViewModel.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 29/03/22.
//

import Foundation

protocol FavouriteViewEntity: AnyObject {
    func showFavouritesPOTD(favourites: [POTDFavorite])
}

protocol FavouriteViewModel {
    func loadFavouritesPOTD()
}

class FavouriteViewModelImpl: FavouriteViewModel {
    
    weak var delegate: FavouriteViewEntity?
    let databaseService: RetriveFavouriteService
    
    public init(databaseService: RetriveFavouriteService) {
        self.databaseService = databaseService
    }
    
    func loadFavouritesPOTD() {
        databaseService.retriveFavouritePOTD { [weak self] listOfFavourites in
            self?.delegate?.showFavouritesPOTD(favourites: listOfFavourites)
        }
    }
}
