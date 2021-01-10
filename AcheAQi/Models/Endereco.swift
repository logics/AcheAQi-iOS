//
//  Endereco.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 07/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation

// MARK: - Endereco
class Endereco: Codable {
    let id: Int?
    var tipo: String = "entrega"
    let logradouro: String
    let numero, complemento: String?
    let estado, cidade, bairro, cep: String
    let createdAt, updatedAt: String?
    
    init(id: Int? = nil, tipo: String = "entrega", logradouro: String, complemento: String? = nil, numero: String?, estado: String, cidade: String, bairro: String, cep: String, createdAt: String? = nil, updatedAt: String? = nil) {
        self.id = id
        self.tipo = tipo
        self.logradouro = logradouro
        self.complemento = complemento
        self.numero = numero
        self.estado = estado
        self.cidade = cidade
        self.bairro = bairro
        self.cep = cep
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: Endereco convenience initializers and mutators

extension Endereco {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Endereco.self, from: data)
        self.init(id: me.id, tipo: me.tipo, logradouro: me.logradouro, complemento: me.complemento, numero: me.numero, estado: me.estado, cidade: me.cidade, bairro: me.bairro, cep: me.cep, createdAt: me.createdAt, updatedAt: me.updatedAt)
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
        tipo: String? = nil,
        logradouro: String? = nil,
        complemento: String? = nil,
        numero: String? = nil,
        estado: String? = nil,
        cidade: String? = nil,
        bairro: String? = nil,
        cep: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil
    ) -> Endereco {
        return Endereco(
            id: id ?? self.id,
            tipo: tipo ?? self.tipo,
            logradouro: logradouro ?? self.logradouro,
            complemento: complemento ?? self.complemento,
            numero: numero ?? self.numero,
            estado: estado ?? self.estado,
            cidade: cidade ?? self.cidade,
            bairro: bairro ?? self.bairro,
            cep: cep ?? self.cep,
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
