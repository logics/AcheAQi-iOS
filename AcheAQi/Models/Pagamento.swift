//
//  Pagamento.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 07/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation

// MARK: - Pagamento
class Pagamento: Codable {
    let id: Int
    let empresa: Empresa
    let gateway, nomeCliente: String
    let cartao: Cartao
    let pedidoID: Int
    let valor: Float
    let proofOfSale, paymentID, authorizationCode, returnMessage: String?
    let tid, returnCode, status: String
    let pedido: Pedido
    let usuario: String
    let cvv: Int
    let createdAt, updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, empresa, gateway, nomeCliente, cartao
        case pedidoID = "pedidoId"
        case valor, proofOfSale
        case tid = "TID"
        case paymentID = "paymentId"
        case authorizationCode, returnCode, status, returnMessage, createdAt, updatedAt, pedido, usuario, cvv
    }
    
    init(id: Int, empresa: Empresa, gateway: String, nomeCliente: String, cartao: Cartao, pedidoID: Int, valor: Float, proofOfSale: String?, tid: String, paymentID: String?, authorizationCode: String?, returnCode: String, status: String, returnMessage: String?, createdAt: Date, updatedAt: Date, pedido: Pedido, usuario: String, cvv: Int) {
        self.id = id
        self.empresa = empresa
        self.gateway = gateway
        self.nomeCliente = nomeCliente
        self.cartao = cartao
        self.pedidoID = pedidoID
        self.valor = valor
        self.proofOfSale = proofOfSale
        self.tid = tid
        self.paymentID = paymentID
        self.authorizationCode = authorizationCode
        self.returnCode = returnCode
        self.status = status
        self.returnMessage = returnMessage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pedido = pedido
        self.usuario = usuario
        self.cvv = cvv
    }
}

// MARK: Pagamento convenience initializers and mutators

extension Pagamento {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Pagamento.self, from: data)
        self.init(id: me.id, empresa: me.empresa, gateway: me.gateway, nomeCliente: me.nomeCliente, cartao: me.cartao, pedidoID: me.pedidoID, valor: me.valor, proofOfSale: me.proofOfSale, tid: me.tid, paymentID: me.paymentID, authorizationCode: me.authorizationCode, returnCode: me.returnCode, status: me.status, returnMessage: me.returnMessage, createdAt: me.createdAt, updatedAt: me.updatedAt, pedido: me.pedido, usuario: me.usuario, cvv: me.cvv)
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
        gateway: String? = nil,
        nomeCliente: String? = nil,
        cartao: Cartao? = nil,
        pedidoID: Int? = nil,
        valor: Float? = nil,
        proofOfSale: String? = nil,
        tid: String? = nil,
        paymentID: String? = nil,
        authorizationCode: String? = nil,
        returnCode: String? = nil,
        status: String? = nil,
        returnMessage: String? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        pedido: Pedido? = nil,
        usuario: String? = nil,
        cvv: Int? = nil
    ) -> Pagamento {
        return Pagamento(
            id: id ?? self.id,
            empresa: empresa ?? self.empresa,
            gateway: gateway ?? self.gateway,
            nomeCliente: nomeCliente ?? self.nomeCliente,
            cartao: cartao ?? self.cartao,
            pedidoID: pedidoID ?? self.pedidoID,
            valor: valor ?? self.valor,
            proofOfSale: proofOfSale ?? self.proofOfSale,
            tid: tid ?? self.tid,
            paymentID: paymentID ?? self.paymentID,
            authorizationCode: authorizationCode ?? self.authorizationCode,
            returnCode: returnCode ?? self.returnCode,
            status: status ?? self.status,
            returnMessage: returnMessage ?? self.returnMessage,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            pedido: pedido ?? self.pedido,
            usuario: usuario ?? self.usuario,
            cvv: cvv ?? self.cvv
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
