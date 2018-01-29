//
//  ArbitraryJSONCodable.swift
//  ArbitraryJSONCodable
//
//  Created by Catigbe, Karl on 1/28/18.
//

import Foundation

struct ArbitraryCodingKeys: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }

}

public extension KeyedDecodingContainer {
    public func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }

    public func decode(_ type: [String: Any].Type, forKey key: KeyedDecodingContainer.Key) throws -> [String: Any] {
        let container = try nestedContainer(keyedBy: ArbitraryCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    public func decodeIfPresent(_ type: [String: Any].Type, forKey key: KeyedDecodingContainer.Key) throws -> [String: Any]? {
        guard contains(key) else { return nil }
        return try decode(type, forKey: key)
    }

    public func decode(_ type: [Any].Type, forKey key: KeyedDecodingContainer.Key) throws -> [Any] {
        var container = try nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    public func decodeIfPresent(_ type: [Any].Type, forKey key: KeyedDecodingContainer.Key) throws -> [Any]? {
        guard contains(key) else { return nil }
        return try decode(type, forKey: key)
    }
}

public extension UnkeyedDecodingContainer {

    public mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []

        while !isAtEnd {
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let value = try? decode(Int.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode([Any].self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    public mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: ArbitraryCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}

public extension KeyedEncodingContainer {
    public mutating func encode(_ value: [String: Any], forKey key: Key) throws {

        var container = self.nestedContainer(keyedBy: ArbitraryCodingKeys.self, forKey: key)

        for (k, v) in value {
            if let encodingKey = ArbitraryCodingKeys(stringValue: k) {
                switch v {
                case let encodable as Bool:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as String:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Int:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Int8:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Int16:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Int32:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Int64:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as UInt:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as UInt8:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as UInt16:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as UInt32:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as UInt64:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Double:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Float:
                    try container.encode(encodable, forKey: encodingKey)

                // MARK: embedded cases
                case let encodable as [String: Any]:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as [Any]:
                    try container.encode(encodable, forKey: encodingKey)
                default:
                    throw EncodingError.invalidValue(v,
                                                     EncodingError.Context(codingPath: self.codingPath,
                                                                           debugDescription: "Attempted to encode an unsupported type \(type(of: v))"))
                }
            }
        }
    }

    public mutating func encode(_ value: [Any], forKey key: Key) throws {
        var container = nestedUnkeyedContainer(forKey: key)

        for v in value {
            switch v {
            case let encodable as Bool:
                try container.encode(encodable)
            case let encodable as String:
                try container.encode(encodable)
            case let encodable as Int:
                try container.encode(encodable)
            case let encodable as Int8:
                try container.encode(encodable)
            case let encodable as Int16:
                try container.encode(encodable)
            case let encodable as Int32:
                try container.encode(encodable)
            case let encodable as Int64:
                try container.encode(encodable)
            case let encodable as UInt:
                try container.encode(encodable)
            case let encodable as UInt8:
                try container.encode(encodable)
            case let encodable as UInt16:
                try container.encode(encodable)
            case let encodable as UInt32:
                try container.encode(encodable)
            case let encodable as UInt64:
                try container.encode(encodable)
            case let encodable as Double:
                try container.encode(encodable)
            case let encodable as Float:
                try container.encode(encodable)

            // MARK: embedded cases
            case let encodable as [String: Any]:
                try container.encode(encodable)
            case let encodable as [Any]:
                try container.encode(encodable)
            default:
                throw EncodingError.invalidValue(v,
                                                 EncodingError.Context(codingPath: self.codingPath,
                                                                       debugDescription: "Attempted to encode an unsupported type \(type(of: v))"))
            }
        }

    }
}

public extension UnkeyedEncodingContainer {
    public mutating func encode(_ value: [Any]) throws {

        var container = nestedUnkeyedContainer()

        for v in value {
            switch v {
            case let encodable as Bool:
                try container.encode(encodable)
            case let encodable as String:
                try container.encode(encodable)
            case let encodable as Int:
                try container.encode(encodable)
            case let encodable as Int8:
                try container.encode(encodable)
            case let encodable as Int16:
                try container.encode(encodable)
            case let encodable as Int32:
                try container.encode(encodable)
            case let encodable as Int64:
                try container.encode(encodable)
            case let encodable as UInt:
                try container.encode(encodable)
            case let encodable as UInt8:
                try container.encode(encodable)
            case let encodable as UInt16:
                try container.encode(encodable)
            case let encodable as UInt32:
                try container.encode(encodable)
            case let encodable as UInt64:
                try container.encode(encodable)
            case let encodable as Double:
                try container.encode(encodable)
            case let encodable as Float:
                try container.encode(encodable)

            // MARK: embedded cases
            case let encodable as [String: Any]:
                try container.encode(encodable)
            case let encodable as [Any]:
                try container.encode(encodable)
            default:
                throw EncodingError.invalidValue(v,
                                                 EncodingError.Context(codingPath: self.codingPath,
                                                                       debugDescription: "Attempted to encode an unsupported type \(type(of: v))"))
            }
        }

    }

    public mutating func encode(_ value: [String: Any]) throws {
        var container = self.nestedContainer(keyedBy: ArbitraryCodingKeys.self)

        for (k, v) in value {
            if let encodingKey = ArbitraryCodingKeys(stringValue: k) {
                switch v {
                case let encodable as Bool:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as String:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Int:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Int8:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Int16:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Int32:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Int64:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as UInt:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as UInt8:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as UInt16:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as UInt32:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as UInt64:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Double:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as Float:
                    try container.encode(encodable, forKey: encodingKey)

                // MARK: embedded cases
                case let encodable as [String: Any]:
                    try container.encode(encodable, forKey: encodingKey)
                case let encodable as [Any]:
                    try container.encode(encodable, forKey: encodingKey)
                default:
                    throw EncodingError.invalidValue(v,
                                                     EncodingError.Context(codingPath: self.codingPath,
                                                                           debugDescription: "Attempted to encode an unsupported type \(type(of: v))"))
                }
            }
        }
    }
}
