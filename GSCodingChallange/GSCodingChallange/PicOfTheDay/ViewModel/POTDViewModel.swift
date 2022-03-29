//
//  POTDViewModel.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 26/03/22.
//

import Foundation

protocol PODViewDelegate: AnyObject {
    var isPOTDFavorite: Bool { get set }
    func displayPicOfTheDay(data: PictureOfTheDay)
    func showFavuoriteTitleButton(isFavourite: Bool)
    func showError(error: String)
}

protocol POTDViewModel {
    func loadPicOfTheDay()
    func shouldFavoritePOTD(isfavorite: Bool)
    func checkFavouritePOTD()
    func loadPicOfTheDay(by date: Date)
}

class POTDViewModelImpl: POTDViewModel {
    
    weak var delegate: PODViewDelegate?
    private var picOfTheDayModel: PictureOfTheDay?
    let service: NASAService
    let removeFavouriteService: RemoveFavouriteService
    let dateParser = DateParser()
    
    init(service: NASAService, removeFavouriteService: RemoveFavouriteService) {
        self.service = service
        self.removeFavouriteService = removeFavouriteService
    }
    
    func loadPicOfTheDay() {
        service.getAstronomyPicOfTheDay { [weak self] picOfTheDay in
            self?.picOfTheDayModel = picOfTheDay
            self?.delegate?.displayPicOfTheDay(data: picOfTheDay)
        } failure: { [weak self] error in
            self?.delegate?.showError(error: error.localizedDescription)
        }
    }
    
    func shouldFavoritePOTD(isfavorite: Bool) {
        delegate?.isPOTDFavorite = !isfavorite
        if !isfavorite {
            saveFavouritesPOTD()
        } else {
            removeFavouritesPOTD(of: picOfTheDayModel?.date ?? "")
        }
    }
    
    func checkFavouritePOTD() {
        let isFavouriteAdded = removeFavouriteService.searchFavouritePOTD(of: picOfTheDayModel?.date ?? "")
        delegate?.showFavuoriteTitleButton(isFavourite: isFavouriteAdded)
    }
    
    private func saveFavouritesPOTD() {
        DispatchQueue.main.async(qos: .background) { [weak self] in
            guard let picOfTheDayModel = self?.picOfTheDayModel else { return }
            let picOfTheDay = POTDFavorite(context: PersistentStorage.shared.context)
            picOfTheDay.date = picOfTheDayModel.date
            picOfTheDay.explanation = picOfTheDayModel.explanation
            picOfTheDay.mediaURL = picOfTheDayModel.url
            picOfTheDay.title = picOfTheDayModel.title
            PersistentStorage.shared.saveContext()
        }
    }
    
    private func removeFavouritesPOTD(of date: String) {
        DispatchQueue.main.async(qos: .background) { [weak self] in
            let favouritePOTD = self?.removeFavouriteService.deleteFavouritePOTD(of: date)
            guard favouritePOTD != nil else { return }
            PersistentStorage.shared.context.delete(favouritePOTD!)
            PersistentStorage.shared.saveContext()
        }
    }
    
    func loadPicOfTheDay(by date: Date) {
        let strDate = dateParser.parseToString(date: date)
        service.getAstronomyPicOfTheDay(by: strDate) { [weak self] picOfTheDay in
            self?.picOfTheDayModel = picOfTheDay
            self?.delegate?.displayPicOfTheDay(data: picOfTheDay)
        } failure: { [weak self] error in
            self?.delegate?.showError(error: error.localizedDescription)
        }
    }
}
