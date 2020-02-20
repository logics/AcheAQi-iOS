//
//  Empresa.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 19/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//  ========================================================
//
//  To parse the JSON, add this file to your project and do:
//
//   let empresa = try Empresa(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseEmpresa { response in
//     if let empresa = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - Empresa
class Empresa: Codable {
    let id: Int
    let nome, telefone, logomarca, cep: String
    let logradouro, cidade, bairro: String
    let numero: Int
    let complemento, estado: String
    let latitude, longitude: Int
    let createdAt, updatedAt: String
    let status: Bool

    init(id: Int, nome: String, telefone: String, logomarca: String, cep: String, logradouro: String, cidade: String, bairro: String, numero: Int, complemento: String, estado: String, latitude: Int, longitude: Int, createdAt: String, updatedAt: String, status: Bool) {
        self.id = id
        self.nome = nome
        self.telefone = telefone
        self.logomarca = logomarca
        self.cep = cep
        self.logradouro = logradouro
        self.cidade = cidade
        self.bairro = bairro
        self.numero = numero
        self.complemento = complemento
        self.estado = estado
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.status = status
    }
}

// MARK: Empresa convenience initializers and mutators

extension Empresa {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Empresa.self, from: data)
        self.init(id: me.id, nome: me.nome, telefone: me.telefone, logomarca: me.logomarca, cep: me.cep, logradouro: me.logradouro, cidade: me.cidade, bairro: me.bairro, numero: me.numero, complemento: me.complemento, estado: me.estado, latitude: me.latitude, longitude: me.longitude, createdAt: me.createdAt, updatedAt: me.updatedAt, status: me.status)
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
        nome: String? = nil,
        telefone: String? = nil,
        logomarca: String? = nil,
        cep: String? = nil,
        logradouro: String? = nil,
        cidade: String? = nil,
        bairro: String? = nil,
        numero: Int? = nil,
        complemento: String? = nil,
        estado: String? = nil,
        latitude: Int? = nil,
        longitude: Int? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        status: Bool? = nil
    ) -> Empresa {
        return Empresa(
            id: id ?? self.id,
            nome: nome ?? self.nome,
            telefone: telefone ?? self.telefone,
            logomarca: logomarca ?? self.logomarca,
            cep: cep ?? self.cep,
            logradouro: logradouro ?? self.logradouro,
            cidade: cidade ?? self.cidade,
            bairro: bairro ?? self.bairro,
            numero: numero ?? self.numero,
            complemento: complemento ?? self.complemento,
            estado: estado ?? self.estado,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            status: status ?? self.status
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
