//
//  Json4Swift_Base.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/9.
//

import Foundation
struct Json4Swift_Base: Codable {
    let name: String?
    let users: [Json4Swift_User]?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case users = "users"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name)
        self.users = try? container.decodeIfPresent([Json4Swift_User].self, forKey: .users)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.users, forKey: .users)
    }
}

struct Json4Swift_User: Codable {
    let age: Int?

    enum CodingKeys: String, CodingKey {
        case age = "age"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.age = try? container.decodeIfPresent(Int.self, forKey: .age)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.age, forKey: .age)
    }
}
