//
//  NetworkClient.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 26/03/22.
//

import Foundation

protocol NetworkClient {
    func request<T:Decodable>(url: URL?,
                              resultType: T.Type,
                              completionHandler:@escaping(Result<T, NetworkError>)-> Void)
}

class NetworkClientImpl: NetworkClient {

    public func request<T:Decodable>(url: URL?,
                                     resultType: T.Type,
                                     completionHandler:@escaping(Result<T, NetworkError>)-> Void) {
        guard let url = url else {
            return completionHandler(.failure(.invalidURL))
        }
        print("Request", url.absoluteString)
        URLSession.shared.dataTask(with: url) { (data, httpUrlResponse, error) in
            print("response", data)
            if let error = error {
                completionHandler(.failure(.network(error)))
            }
            guard let data = data else {
                completionHandler(.failure(.emptyData))
                return
            }
            do {
                let response = try JSONDecoder().decode(resultType, from: data)
                completionHandler(.success(response))
            } catch let error {
                completionHandler(.failure(.network(error)))
            }
        }.resume()
    }
}
