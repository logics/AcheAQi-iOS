//
//  Categoria.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 19/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
// =======================================================
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let categoria = try Categoria(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCategoria { response in
//     if let categoria = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - Categoria
class Categoria: Codable {
    let id: Int
    let nome, createdAt, updatedAt: String
    let foto: String?

    init(id: Int, foto: String?, nome: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.foto = foto
        self.nome = nome
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: Categoria Equatable
extension Categoria: Equatable {
    static func == (lhs: Categoria, rhs: Categoria) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: Categoria convenience initializers and mutators

extension Categoria {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Categoria.self, from: data)
        self.init(id: me.id, foto: me.foto, nome: me.nome, createdAt: me.createdAt, updatedAt: me.updatedAt)
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
        foto: String? = nil,
        nome: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil
    ) -> Categoria {
        return Categoria(
            id: id ?? self.id,
            foto: foto ?? self.foto,
            nome: nome ?? self.nome,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
