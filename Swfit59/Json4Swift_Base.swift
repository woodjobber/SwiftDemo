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

    let status: Status

    enum CodingKeys: String, CodingKey {
        case name
        case users
        case status
    }

    enum Status: Int, CodableEnum {
        static var defaultCase: Json4Swift_Base.Status {
            .a
        }

        case a
        case b
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.users = try container.decodeIfPresent([Json4Swift_User].self, forKey: .users)
        self.status = try container.decode(Json4Swift_Base.Status.self, forKey: .status)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.users, forKey: .users)
        try container.encode(self.status, forKey: .status)
    }
}

struct Json4Swift_User: Codable {
    let age: Int?

    enum CodingKeys: String, CodingKey {
        case age
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

protocol CodableEnum: RawRepresentable, Codable where RawValue: Codable {
    static var defaultCase: Self { get
    }
}

extension CodableEnum {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let decoded = try container.decode(RawValue.self)
            self = Self(rawValue: decoded) ?? Self.defaultCase
        } catch {
            self = Self.defaultCase
        }
    }
}
