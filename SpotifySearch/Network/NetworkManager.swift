//
//  NetworkManager.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import RxSwift

protocol NetworkingManager {
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T>
}

final class NetworkManager: NetworkingManager {
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return URLRequest.loadWithPayLoad(resource: resource)
    }
}
