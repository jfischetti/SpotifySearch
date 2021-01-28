//
//  AccessToken.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import Foundation

struct AccessToken: Decodable {

    var token: String?

    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}
