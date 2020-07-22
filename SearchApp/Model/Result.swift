//
//  Result.swift
//  SearchApp
//
//  Created by Денис Андриевский on 22.07.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

enum ResultElement: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ResultElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    func value() -> AnyObject {
        switch self {
        case .integer(let x):
            return x as AnyObject
        case .string(let x):
            return x as AnyObject
        }
    }
}

typealias Result = [[ResultElement]]
