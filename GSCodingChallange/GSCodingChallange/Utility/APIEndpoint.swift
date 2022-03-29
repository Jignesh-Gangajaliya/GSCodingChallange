//
//  APIEndpoint.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 26/03/22.
//

import Foundation

public struct APIEndpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension APIEndpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    public var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nasa.gov"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

extension APIEndpoint {
    static func getAstronomyPOD() -> APIEndpoint {
        return APIEndpoint(
            path: "/planetary/apod",
            queryItems: [
                URLQueryItem(name: "api_key", value: Key.apiKey)
            ]
        )
    }
    
    static func getAstronomyPOD(by date: String) -> APIEndpoint {
        return APIEndpoint(
            path: "/planetary/apod",
            queryItems: [
                URLQueryItem(name: "api_key", value: Key.apiKey),
                URLQueryItem(name: "date", value: date)
            ]
        )
    }
}
