//
//  JSONCoding.swift
//  PostsTestProject
//
//  Created by Muhammadjon Madaminov on 12/08/25.
//

import Foundation


protocol JSONCoding {
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
}

final class DefaultJSONCoding: JSONCoding {
    let encoder: JSONEncoder
    let decoder: JSONDecoder

    init() {
        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
}
