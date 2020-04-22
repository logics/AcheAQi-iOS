//
//  Marca.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 21/04/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation

// MARK: - Marca
class Marca: Codable {
    let id: Int
    let nome, createdAt, updatedAt: String
    let logo: String?

    init(id: Int, nome: String, logo: String?, createdAt: String, updatedAt: String) {
        self.id = id
        self.nome = nome
        self.logo = logo
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
