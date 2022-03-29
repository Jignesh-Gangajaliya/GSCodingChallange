//
//  PictureOfTheDay.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 29/03/22.
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
