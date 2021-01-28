//
//  ArtistViewController.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import Foundation
import UIKit

class ArtistViewController: UIViewController {

    var artist: Artist?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!

    static func configure(artist: Artist) -> ArtistViewController? {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "ArtistViewController") as? ArtistViewController
        vc?.artist = artist

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // set image
        DispatchQueue.global(qos: .userInteractive).async {
            if let imageData = self.artist?.images.first, let urlString = imageData.url, let url = URL(string: urlString), let data = try? Data(contentsOf: url) {

                DispatchQueue.main.async {
                    self.imageView?.image = UIImage(data: data)
                }
            }
        }

        // set image placeholder
        self.imageView.image = UIImage.fontAwesomeIcon(name: .image, style: .regular, textColor: .lightGray, size: CGSize(width: 400.0, height: 400.0))

        self.nameLbl.text = self.artist?.name
        if let followers = self.artist?.followers.total {
            // format followers with commas
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            self.followersLbl.text = "Followers: \(numberFormatter.string(from: NSNumber(value: followers)) ?? "0")"
        }
    }
}
