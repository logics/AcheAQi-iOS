//
//  Pedido.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 07/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation

enum FormaPagamento: String {
    case dinheiro = "dinheiro"
    case cartao = "cartao"
}

enum StatusInfoPag: String {
    case Processando = "Processando"
    case Autorizado = "Autorizado"
    case Pago = "Pago"
    case Reembolsado = "Reembolsado"
    case Aguardando = "Aguardando pagamento"
    case ReembolsoPendente = "Reembolso pendente"
    case Recusado = "Recusado"
}

// MARK: - Pedido
class Pedido: Codable {
    let id: Int?
    let empresa: Empresa?
    let formaPagamento: String
    let entrega: Bool
    var endereco: Endereco?
    var itens: PedidoItens
    var cartao: Cartao?
    let valorTotal: Float?
    let createdAt, updatedAt: Date?
    let pagamentos: Pagamentos?
    
    var statusInfo: StatusInfoPag {
        let status = StatusInfoPag.Aguardando
        
        if let pagamento = self.pagamentos?.first {
            
            switch pagamento.status {
                case "processing":      return StatusInfoPag.Processando
                case "authorized":      return StatusInfoPag.Autorizado
                case "paid":            return StatusInfoPag.Pago
                case "refunded":        return StatusInfoPag.Reembolsado
                case "waiting_payment": return StatusInfoPag.Aguardando
                case "pending_refund":  return StatusInfoPag.ReembolsoPendente
                case "refused":         return StatusInfoPag.Recusado
                default: return status
            }
        }
        
        return status
    }

    init(id: Int? = nil, empresa: Empresa? = nil, formaPagamento: String, entrega: Bool, endereco: Endereco? = nil, itens: PedidoItens = PedidoItens(), cartao: Cartao? = nil, valorTotal: Float? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, pagamentos: Pagamentos? = nil) {
        self.id = id
        self.empresa = empresa
        self.formaPagamento = formaPagamento
        self.endereco = endereco
        self.entrega = entrega
        self.itens = itens
        self.cartao = cartao
        self.valorTotal = valorTotal
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pagamentos = pagamentos
    }
}

// MARK: Pedido convenience initializers and mutators

extension Pedido {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Pedido.self, from: data)
        self.init(id: me.id, empresa: me.empresa, formaPagamento: me.formaPagamento, entrega: me.entrega, endereco: me.endereco, itens: me.itens, cartao: me.cartao, valorTotal: me.valorTotal, createdAt: me.createdAt, updatedAt: me.updatedAt, pagamentos: me.pagamentos)
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
        formaPagamento: String? = nil,
        entrega: Bool? = nil,
        endereco: Endereco? = nil,
        itens: PedidoItens? = nil,
        cartao: Cartao? = nil,
        valorTotal: Float? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        pagamentos: Pagamentos? = nil
    ) -> Pedido {
        return Pedido(
            id: id ?? self.id,
            empresa: empresa ?? self.empresa,
            formaPagamento: formaPagamento ?? self.formaPagamento,
            entrega: entrega ?? self.entrega,
            endereco: endereco ?? self.endereco,
            itens: itens ?? self.itens,
            cartao: cartao ?? self.cartao,
            valorTotal: valorTotal ?? self.valorTotal,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            pagamentos: pagamentos ?? self.pagamentos
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
