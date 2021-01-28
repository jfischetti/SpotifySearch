//
//  ArtistTableViewCell.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import Foundation
import UIKit

class ArtistTableViewCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.imageView?.image = nil
        self.textLabel?.text = nil
    }
}
