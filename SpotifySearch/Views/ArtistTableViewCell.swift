//
//  ArtistTableViewCell.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import Foundation
import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        self.artistImage?.image = nil
        self.artistName?.text = nil
    }
}
