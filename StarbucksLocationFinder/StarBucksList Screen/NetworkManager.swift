//
//  NetworkManager.swift
//  StarbucksLocationFinder
//
//  Created by Manu on 30/01/24.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(from url: URL) -> AnyPublisher<T, Error>
}

class NetworkManager: NetworkManagerProtocol {
    static let apiKey = "AIzaSyA8SfOoQ-8S-OYo2SGVBrtsTlwSRGPxX80"
    static let shared = NetworkManager()

    private init() {}

    func fetchData<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}




