//
//  Cartao.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 07/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation

// MARK: - Cartão
class Cartao: Codable {
    let id: Int
    let usuario, gateway, cardToken, cardType, provider: String?
    let brand: String
    let isInternational: Bool?
    let isDefault: Bool
    let lastDigits: Int?
    let createdAt, updatedAt: Date?
    let titular: String
    let ativo: Bool
    
    init(id: Int = 0, usuario: String? = nil, gateway: String? = nil, cardToken: String? = nil, cardType: String?, brand: String, provider: String? = nil, isInternational: Bool? = nil, isDefault: Bool, lastDigits: Int? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, titular: String, ativo: Bool = true) {
        self.id = id
        self.usuario = usuario
        self.gateway = gateway
        self.cardToken = cardToken
        self.cardType = cardType
        self.brand = brand
        self.provider = provider
        self.isInternational = isInternational
        self.isDefault = isDefault
        self.lastDigits = lastDigits
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.titular = titular
        self.ativo = ativo
    }
    
    func maskedNumber() -> String {
        guard let lastDigits = self.lastDigits else { return "XXXX - XXXX - XXXX - XXXX" }
        
        let trailling = lastDigits > 0 ? String(lastDigits) : "XXXX"
        return String(format: "XXXX - XXXX - XXXX - %@", trailling)
    }
}

// MARK: Cartao convenience initializers and mutators

extension Cartao {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Cartao.self, from: data)
        self.init(id: me.id, usuario: me.usuario, gateway: me.gateway, cardToken: me.cardToken, cardType: me.cardType, brand: me.brand, provider: me.provider, isInternational: me.isInternational, isDefault: me.isDefault, lastDigits: me.lastDigits, createdAt: me.createdAt, updatedAt: me.updatedAt, titular: me.titular, ativo: me.ativo)
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
        usuario: String? = nil,
        gateway: String? = nil,
        cardToken: String? = nil,
        cardType: String? = nil,
        brand: String? = nil,
        provider: String? = nil,
        isInternational: Bool? = nil,
        isDefault: Bool? = nil,
        lastDigits: Int? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        titular: String? = nil,
        ativo: Bool? = nil
    ) -> Cartao {
        return Cartao(
            id: id ?? self.id,
            usuario: usuario ?? self.usuario,
            gateway: gateway ?? self.gateway,
            cardToken: cardToken ?? self.cardToken,
            cardType: cardType ?? self.cardType,
            brand: brand ?? self.brand,
            provider: provider ?? self.provider,
            isInternational: isInternational ?? self.isInternational,
            isDefault: isDefault ?? self.isDefault,
            lastDigits: lastDigits ?? self.lastDigits,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            titular: titular ?? self.titular,
            ativo: ativo ?? self.ativo
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
