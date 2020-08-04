//
//  Dog.swift
//  PetFinder
//
//  Created by Marcy Vernon on 8/2/20.
//

import Foundation

struct Dog: Decodable {
    let breeds : [Breeds]?

    enum CodingKeys: String, CodingKey {
        case breeds = "breeds"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        breeds = try values.decodeIfPresent([Breeds].self, forKey: .breeds)
    }
}

struct Breeds : Decodable {
    let name : String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
