//
//  SearchViewController.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import FontAwesome_swift

class SearchViewController : UIViewController {

    private let disposeBag = DisposeBag()
    var viewModel: SearchViewModelProtocol?
    var artists: [Artist]?

    @IBOutlet weak var tableView: UITableView!

    static func configure() -> SearchViewController? {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "SearchViewController") as? SearchViewController
        vc?.viewModel = SearchViewModel(api: SpotifyAPI(NetworkManager()))

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupBindings()
    }

    func setupUI() {
        // configure search bar
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search artists"
        navigationItem.searchController = search

        showNoContentView()
    }

    func setupBindings() {

        // bind table view datasource
        self.viewModel?.artists.subscribe(onNext: { artists in
            self.artists = artists

            DispatchQueue.main.async {
                if artists.count == 0 {
                    self.showNoContentView()
                } else {
                    self.dismissNoContentView()
                }
            }
        })
        .disposed(by: disposeBag)

        _ = self.viewModel?.artists.bind(to: self.tableView.rx.items(cellIdentifier: "Artist", cellType: ArtistTableViewCell.self)) { index, artist, cell in

            // set image
            DispatchQueue.global(qos: .userInteractive).async {
                if let imageData = artist.images.first, let urlString = imageData.url, let url = URL(string: urlString), let data = try? Data(contentsOf: url) {

                    DispatchQueue.main.async {
                        cell.artistImage?.image = UIImage(data: data)
                        cell.setNeedsLayout()
                    }
                } else {
                    DispatchQueue.main.async {
                        // set default image
                        cell.artistImage?.image = UIImage.fontAwesomeIcon(name: .image, style: .regular, textColor: .lightGray, size: CGSize(width: 400.0, height: 400.0))
                        cell.setNeedsLayout()
                    }
                }
            }

            cell.artistName?.text = artist.name
        }
        .disposed(by: disposeBag)

        // bind search bar text inputs
        navigationItem.searchController?.searchBar.rx.text.subscribe(onNext: { (query) in
            if let query = query, query.count > 0 {
                print("Searching: \(query)")
                self.dismissNoContentView()
                self.viewModel?.searchArtists(query: query)
            }
        })
        .disposed(by: disposeBag)

        // set UITableViewDelegate
        tableView.delegate = self
    }

    func showNoContentView() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        messageLabel.text = "No artists found. Try searching!"
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 32)
        messageLabel.sizeToFit()

        self.tableView.backgroundView = messageLabel
        self.tableView.separatorStyle = .none
    }

    func dismissNoContentView() {
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
    }
}

extension SearchViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let artist = self.artists?[indexPath.row], let vc = ArtistViewController.configure(artist: artist) {
            self.navigationController?.pushViewController(vc, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

