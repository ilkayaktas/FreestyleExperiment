// To parse the JSON, add this file to your project and do:
//
//   let currencyList = try CurrencyList(json)

import Foundation

typealias CurrencyList = [CurrencyListElement]

struct CurrencyListElement: Codable {
    let selling: Double
    let updateDate, currency: Int
    let buying, changeRate: Double
    let name, fullName, code: String
    
    // If you don’t use certain properties in your struct that are included in the JSON,
    // that’s fine, but if you want to use a different property name in your struct than in the JSON,
    // you’ll need to include an enum that specifies these property names in your struct
    enum CodingKeys: String, CodingKey {
        case selling
        case updateDate = "update_date"
        case currency, buying
        case changeRate = "change_rate"
        case name
        case fullName = "full_name"
        case code
    }
}

// MARK: Convenience initializers

extension CurrencyListElement {
    init(data: Data) throws {
        self = try JSONDecoder().decode(CurrencyListElement.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == CurrencyList.Element {
    init(data: Data) throws {
        self = try JSONDecoder().decode(CurrencyList.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
