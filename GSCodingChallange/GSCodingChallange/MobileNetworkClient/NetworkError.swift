//
//  NetworkError.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 26/03/22.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case emptyData
    case noNetwork
    case network(Error)
}
