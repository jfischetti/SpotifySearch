//
//  URLRequest+Extensions.swift
//  SpotifySearch
//
//  Created by Joseph Fischetti on 1/27/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

struct Resource<T> {
    let url: URL
    let token: String?
    var parameter: [String: String]?
    var httpMethod: String = "GET"
}

extension URLRequest {

    static func loadWithPayLoad<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                var request = URLRequest(url: self.loadURL(resource: resource) ?? url)

                if let token = resource.token {
                    // set the Auth header
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }

                if resource.httpMethod != "GET" {
                    // this is not a GET so it will require an httpBody
                    request.httpMethod = resource.httpMethod

                    if let body = resource.parameter {
                        // encode the body
                        let payloadString = body.reduce("") { "\($0)\($1.key)=\($1.value)&" }.dropLast()
                        request.httpBody = payloadString.data(using: .utf8)
                    }

                    // set the Auth header
                    let creds = "\(NetworkConstants.clientID):\(NetworkConstants.clientSecret)"
                    let base64 = Data(creds.utf8).base64EncodedString()
                    request.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                }

                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in

                if 200 ..< 300 ~= response.statusCode {
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }

            }.asObservable()
    }

    /// Construct the url with query string
    static func loadURL<T>(resource: Resource<T>) -> URL? {
        if resource.httpMethod == "GET", let parameters = resource.parameter, let urlComponents = URLComponents(url: resource.url, resolvingAgainstBaseURL: false) {
            var components = urlComponents
            components.queryItems = parameters.map {
                let (key, value) = $0
                return URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            return components.url
        }
        return nil
    }
}
