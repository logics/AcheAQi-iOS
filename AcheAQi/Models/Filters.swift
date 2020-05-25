//
//  Filters.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 28/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation

struct Filters {
    private(set) public var count: Int = 0
    
    var useLocation: Bool = false {
        didSet {
            if self.useLocation {
                self.count += 1
            }
            else if self.count > 0 {
                self.count -= 1
            }
        }
    }
    
    var categorias = Categorias() {
        didSet {
            self.count = self.categorias.count + (self.useLocation ? 1 : 0)
        }
    }
    
    mutating func toogleCategoria(_ categoria: Categoria) {
        if categorias.contains(categoria), let index = categorias.firstIndex(of: categoria) {
            self.categorias.remove(at: index)
        }
        else {
            categorias.removeAll()
            categorias.append(categoria)
        }
    }
}
