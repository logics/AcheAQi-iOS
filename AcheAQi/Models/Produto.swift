//
//  Produto.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 19/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Produto
class Produto: NSObject, Codable {
    let id: Int
    let empresa: Empresa
    let categoria: Categoria
    let nome, banner, createdAt, updatedAt: String
    let foto, descricao: String
    let mostraValor: Bool
    let valor: Float

    init(id: Int, empresa: Empresa, categoria: Categoria, nome: String, banner: String, createdAt: String, updatedAt: String, foto: String, descricao: String, mostraValor: Bool, valor: Float) {
        self.id = id
        self.empresa = empresa
        self.categoria = categoria
        self.nome = nome
        self.banner = banner
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.foto = foto
        self.descricao = descricao
        self.mostraValor = mostraValor
        self.valor = valor
    }
    enum CodingKeys: String, CodingKey {
        case id
        case empresa
        case categoria
        case nome
        case banner
        case createdAt
        case updatedAt
        case foto
        case descricao
        case mostraValor
        case valor
    }

    /// NSPredicate expression keys for searching.
    enum ExpressionKeys: String {
        case nome
    }
}

// MARK: Produto convenience initializers and mutators

extension Produto {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Produto.self, from: data)
        self.init(id: me.id, empresa: me.empresa, categoria: me.categoria, nome: me.nome, banner: me.banner, createdAt: me.createdAt, updatedAt: me.updatedAt, foto: me.foto, descricao: me.descricao, mostraValor: me.mostraValor, valor: me.valor)
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
        empresa: Empresa? = nil,
        categoria: Categoria? = nil,
        nome: String? = nil,
        banner: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        foto: String? = nil,
        descricao: String? = nil,
        mostraValor: Bool? = nil,
        valor: Float? = nil
    ) -> Produto {
        return Produto(
            id: id ?? self.id,
            empresa: empresa ?? self.empresa,
            categoria: categoria ?? self.categoria,
            nome: nome ?? self.nome,
            banner: banner ?? self.banner,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            foto: foto ?? self.foto,
            descricao: descricao ?? self.descricao,
            mostraValor: mostraValor ?? self.mostraValor,
            valor: valor ?? self.valor
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

