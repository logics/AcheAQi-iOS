//
//  PedidoItem.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 07/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation

// MARK: - PedidoItem
class PedidoItem: Codable {
    let id: Int?
    let produto: Produto
    let valorUnitario: Float
    var qtd: Int
    let pedido: Pedido
    let createdAt, updatedAt: Date?
    
    init(id: Int? = nil, produto: Produto, qtd: Int, valorUnitario: Float, pedido: Pedido, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.produto = produto
        self.qtd = qtd
        self.valorUnitario = valorUnitario
        self.pedido = pedido
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func increase() {
        qtd += 1
    }
    
    func decrease() {
        guard qtd > 1 else { return }
        qtd -= 1
    }
}

// MARK: PedidoItem convenience initializers and mutators

extension PedidoItem {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PedidoItem.self, from: data)
        self.init(id: me.id, produto: me.produto, qtd: me.qtd, valorUnitario: me.valorUnitario, pedido: me.pedido, createdAt: me.createdAt, updatedAt: me.updatedAt)
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
        produto: Produto? = nil,
        qtd: Int? = nil,
        valorUnitario: Float? = nil,
        pedido: Pedido? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) -> PedidoItem {
        return PedidoItem(
            id: id ?? self.id,
            produto: produto ?? self.produto,
            qtd: qtd ?? self.qtd,
            valorUnitario: valorUnitario ?? self.valorUnitario,
            pedido: pedido ?? self.pedido,
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
