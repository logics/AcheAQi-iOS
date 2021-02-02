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
class Produto: Codable {
    let id: Int
    let empresa: Empresa
    let categoria: Categoria
    let marca: Marca?
    let nome, createdAt, updatedAt: String
    let banner, descricao: String?
    let mostraValor, emEstoque: Bool
    let valor: Float
    let emPromocao: Bool
    let percDesconto, valorPromocional: Float?
    var valorAtual: Float
    var fotos: Fotos
    
    var percClean: String {
        return ((percDesconto ?? 0.0) * 100.0).rounded().clean
    }
    
    var fotoPrincipal: Foto? {
        return fotos.first
    }

    init(id: Int, empresa: Empresa, categoria: Categoria, marca: Marca?, nome: String, banner: String?, createdAt: String, updatedAt: String, descricao: String?, emEstoque: Bool, mostraValor: Bool, valor: Float, emPromocao: Bool, percDesconto: Float?, valorPromocional: Float?, valorAtual: Float, fotos: Fotos? = nil) {
        self.id = id
        self.empresa = empresa
        self.categoria = categoria
        self.marca = marca
        self.nome = nome
        self.banner = banner
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.descricao = descricao
        self.emEstoque = emEstoque
        self.mostraValor = mostraValor
        self.valor = valor
        self.emPromocao = emPromocao
        self.percDesconto = percDesconto
        self.valorPromocional = valorPromocional
        self.valorAtual = valorAtual
        self.fotos = fotos ?? Fotos()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case empresa
        case categoria
        case marca
        case nome
        case banner
        case createdAt
        case updatedAt
        case descricao
        case emEstoque
        case mostraValor
        case valor
        case emPromocao
        case percDesconto
        case valorPromocional
        case valorAtual
        case fotos
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
        self.init(id: me.id, empresa: me.empresa, categoria: me.categoria, marca: me.marca, nome: me.nome, banner: me.banner, createdAt: me.createdAt, updatedAt: me.updatedAt, descricao: me.descricao, emEstoque: me.emEstoque, mostraValor: me.mostraValor, valor: me.valor, emPromocao: me.emPromocao, percDesconto: me.percDesconto, valorPromocional: me.valorPromocional, valorAtual: me.valorAtual, fotos: me.fotos)
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
        marca: Marca? = nil,
        nome: String? = nil,
        banner: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        descricao: String? = nil,
        emEstoque: Bool? = nil,
        mostraValor: Bool? = nil,
        valor: Float? = nil,
        emPromocao: Bool = false,
        percDesconto: Float? = nil,
        valorPromocional: Float? = nil,
        valorAtual: Float? = nil,
        fotos: Fotos? = nil
    ) -> Produto {
        return Produto(
            id: id ?? self.id,
            empresa: empresa ?? self.empresa,
            categoria: categoria ?? self.categoria,
            marca: marca ?? self.marca,
            nome: nome ?? self.nome,
            banner: banner ?? self.banner,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            descricao: descricao ?? self.descricao,
            emEstoque: emEstoque ?? self.emEstoque,
            mostraValor: mostraValor ?? self.mostraValor,
            valor: valor ?? self.valor,
            emPromocao: emPromocao,
            percDesconto: percDesconto ?? self.percDesconto,
            valorPromocional: valorPromocional ?? self.valorPromocional,
            valorAtual: valorAtual ?? self.valorAtual,
            fotos: fotos ?? self.fotos
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Equatable
extension Produto: Equatable {
    static func ==(lhs: Produto, rhs: Produto) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Produtos where Element: Produto {
    func filter(term: String, filters: Filters? = nil) -> Produtos {
        var result = self
        
        if term.length > 0 {
            result = filter { item -> Bool in
                let stringData = NSString(string: item.nome + item.empresa.nome + item.categoria.nome + (item.marca?.nome ?? ""))
                
                return stringData.localizedStandardContains(term)
            }
        }
        
        if let categoria = filters?.categorias.first {
            result = result.filter({ item -> Bool in
                return item.categoria == categoria
            })
        }
        
        return result
    }
}
