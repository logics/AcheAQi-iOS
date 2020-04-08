//
//  Foto.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 19/03/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation

// MARK: - Foto
class Foto: Codable {
    let id: Int
    let path: String
    let createdAt, updatedAt: Date
    let position: Int

    init(id: Int, path: String, createdAt: Date, updatedAt: Date, position: Int) {
        self.id = id
        self.path = path
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.position = position
    }
}

// MARK: Foto convenience initializers and mutators

extension Foto {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Foto.self, from: data)
        self.init(id: me.id, path: me.path, createdAt: me.createdAt, updatedAt: me.updatedAt, position: me.position)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int? = nil,
        path: String? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        position: Int = 1
    ) -> Foto {
        return Foto(
            id: id ?? self.id,
            path: path ?? self.path,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            position: position
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
