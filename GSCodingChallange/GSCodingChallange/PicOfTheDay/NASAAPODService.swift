//
//  NASAAPODService.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 26/03/22.
//

import Foundation

class PictureOfTheDay : Decodable {
    let date: String
    let explanation: String
    let hdurl: String
    let media_type: String
    let service_version: String
    let title: String
    let url: String
    var isFavorite: Bool?
}

protocol NASAService {
    func getAstronomyPicOfTheDay(completionSuccess: @escaping (PictureOfTheDay) -> Void,
                                 failure: @escaping (Error) -> Void)
    func getAstronomyPicOfTheDay(by date: String,
                                 completionSuccess: @escaping (PictureOfTheDay) -> Void,
                                 failure: @escaping (Error) -> Void)
}

struct NASAServiceImpl: NASAService {
    let apiService: NetworkClient
    
    init(apiService: NetworkClient) {
        self.apiService = apiService
    }
    
    func getAstronomyPicOfTheDay(completionSuccess: @escaping (PictureOfTheDay) -> Void,
                                 failure: @escaping (Error) -> Void) {
        let endPoint = APIEndpoint.getAstronomyPOD()
        apiService.request(url: endPoint.url, resultType: PictureOfTheDay.self) { result in
            switch result {
            case .success(let podModel):
                completionSuccess(podModel)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getAstronomyPicOfTheDay(by date: String,
                                 completionSuccess: @escaping (PictureOfTheDay) -> Void,
                                 failure: @escaping (Error) -> Void) {
        let endPoint = APIEndpoint.getAstronomyPOD(by: date)
        apiService.request(url: endPoint.url, resultType: PictureOfTheDay.self) { result in
            switch result {
            case .success(let podModel):
                completionSuccess(podModel)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
