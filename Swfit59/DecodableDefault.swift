//
//  DecodableDefault.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/10.
//

import Foundation

protocol DecodableDefaultSource {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

enum DecodableDefault {}

extension DecodableDefault {
    @propertyWrapper
    struct Wrapper<Source: DecodableDefaultSource> {
        typealias Value = Source.Value
        var defaultValue: Value

        var wrappedValue: Value {
            get {
                return defaultValue
            }
            set {
                defaultValue = newValue
            }
        }

        init(wrappedValue: Value) {
            defaultValue = wrappedValue
        }
        
        init() {
            defaultValue =  Source.defaultValue
        }
    }
}

extension DecodableDefault.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        defaultValue = try container.decode(Value.self)
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: DecodableDefault.Wrapper<T>.Type,
                   forKey key: Key) throws -> DecodableDefault.Wrapper<T>
    {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
}

extension DecodableDefault {
    typealias Source = DecodableDefaultSource
    typealias List = Decodable & ExpressibleByArrayLiteral
    typealias Map = Decodable & ExpressibleByDictionaryLiteral
    enum Sources {
        enum True: Source { static var defaultValue: Bool { true } }
        enum False: Source { static var defaultValue: Bool { false } }
        enum EmptyString: Source { static var defaultValue: String { "" } }
        enum EmptyList<T: List>: Source { static var defaultValue: T { []} }
        enum EmptyMap<T: Map>: Source { static var defaultValue: T { [:] } }
        enum Zero: Source { static var defaultValue: Int { .zero} }
    }
    
}

extension DecodableDefault {
    typealias True = Wrapper<Sources.True>
    typealias False = Wrapper<Sources.False>
    typealias EmptyString = Wrapper<Sources.EmptyString>
    typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>
    typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>
    typealias Zero = Wrapper<Sources.Zero>
}

extension DecodableDefault.Wrapper: Equatable where Value: Equatable {}
extension DecodableDefault.Wrapper: Hashable where Value: Hashable {}

extension DecodableDefault.Wrapper: Encodable where Value: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

