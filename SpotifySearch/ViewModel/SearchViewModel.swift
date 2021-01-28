//
//  SearchViewModel.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import RxSwift

protocol SearchViewModelProtocol {

    /// Observable for view to bind to.
    var artists: Observable<[Artist]> { get }

    /// Searches for artists with the given query and then updates the artists observable.
    /// - Parameter query: A search parameter.
    func searchArtists(query: String)
}

class SearchViewModel: SearchViewModelProtocol {

    var artists: Observable<[Artist]>
    private let disposeBag = DisposeBag()
    private let api: SpotifyAPIProtocol
    private let artistsSubject = PublishSubject<[Artist]>()

    init(api: SpotifyAPIProtocol) {
        self.api = api
        self.artists = artistsSubject.asObserver()
    }

    func searchArtists(query: String) {
        api.searchArtists(query: query)
            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just([])
            }
            .subscribe(onNext: { [weak self] results in
                // update observers
                self?.artistsSubject.onNext(results)
            })
            .disposed(by: disposeBag)
    }
}
