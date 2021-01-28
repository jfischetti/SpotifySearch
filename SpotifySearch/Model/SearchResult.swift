//
//  SearchResult.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import Foundation

struct SearchResponse: Decodable {

    let artists: [Artist]?

    enum CodingKeys: String, CodingKey {
        case artists, items
    }

    /*
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artists = try container.decode([Artist].self, forKey: .items)
    }*/
}
