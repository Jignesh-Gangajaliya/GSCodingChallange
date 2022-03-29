//
//  POTDViewModel.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 26/03/22.
//

import Foundation

protocol PODViewDelegate: AnyObject {
    func displayPicOfTheDay(data: PictureOfTheDay)
    func showError(error: String)
}

protocol POTDViewModel {
    func loadPicOfTheDay()
    func shouldFavoritePOTD(isfavorite: Bool, for date: String)
    func loadPicOfTheDay(by date: Date)
}

class PODViewModelImpl: POTDViewModel {
    
    weak var delegate: PODViewDelegate?
    var favoritePOTD = [PictureOfTheDay]()
    let service: NASAService
    let dateParser = DateParser()
    
    init(service: NASAService) {
        self.service = service
    }
    
    func loadPicOfTheDay() {
        service.getAstronomyPicOfTheDay { [weak self] picOfTheDay in
            self?.delegate?.displayPicOfTheDay(data: picOfTheDay)
        } failure: { [weak self] error in
            self?.delegate?.showError(error: error.localizedDescription)
        }
    }
    
    func shouldFavoritePOTD(isfavorite: Bool, for date: String) {
        let favorite = favoritePOTD.contains(where: { $0.date == date })
        if favorite {
            
        } else {
            
        }
    }
    
    func loadPicOfTheDay(by date: Date) {
        let strDate = dateParser.parseToString(date: date)
        service.getAstronomyPicOfTheDay(by: strDate) { [weak self] picOfTheDay in
            self?.delegate?.displayPicOfTheDay(data: picOfTheDay)
        } failure: { [weak self] error in
            self?.delegate?.showError(error: error.localizedDescription)
        }
    }
}
