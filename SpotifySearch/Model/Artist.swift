//
//  Artist.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import Foundation

struct Artist: Decodable {
    let name: String
    let id: String
    let images: [ArtistImage]
    let followers: Followers
}
