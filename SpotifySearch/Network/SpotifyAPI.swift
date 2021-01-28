//
//  SpotifyAPI.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import RxSwift

protocol SpotifyAPIProtocol {
    func searchArtists(query: String) -> Observable<[Artist]>
}

class SpotifyAPI: SpotifyAPIProtocol {

    private let networkingManager: NetworkingManager
    private var apiToken: String?
    private let disposeBag = DisposeBag()

    init(_ networkingManager: NetworkingManager) {
        self.networkingManager = networkingManager

        self.authenticateAPI()
            .retry(2)
            .catch {
                print($0.localizedDescription)
                return Observable.just(AccessToken.init())
            }
            .subscribe(onNext: { results in
                print("\(results)")
            })
            .disposed(by: disposeBag)
    }

    private func authenticateAPI() -> Observable<AccessToken> {
        let urlString = NetworkConstants.tokenURL
        let url = URL(string: urlString)!

        let body = ["grant_type": "client_credentials"]

        let resource = Resource<AccessToken>(url: url, token: nil, parameter: body, httpMethod: "POST")

        return networkingManager.load(resource: resource)
            .map { accessToken in
                print("Got accessToken: \(accessToken)")
                self.apiToken = accessToken.token
                return accessToken
            }.asObservable()
    }

    func searchArtists(query: String) -> Observable<[Artist]> {
        let urlString = "\(NetworkConstants.baseURL)\(NetworkConstants.searchPath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlSafeString = urlString, let url = URL(string: urlSafeString) else { return Observable.error(NetworkError.invalidURL) }

        var queryParams: [String: String] = [String: String]()
        queryParams["q"] = query
        queryParams["type"] = "artist"

        let resource = Resource<SearchResponse>(url: url, token: apiToken, parameter: queryParams)

        return networkingManager.load(resource: resource)
            .map { results -> [Artist] in
                results.artists.items
            }
            .asObservable()
            .retry(2)
    }
}
