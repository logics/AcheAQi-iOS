//
//  MainResultsTableController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 20/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

class MainResultsTableController: UITableViewController {
    
    var results: [String] = []
    var empresas = Empresas()
    var produtos = Produtos()
    var categorias = Categorias()

    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Private Methods

    fileprivate func fetchRemoteData(for term: String) {
        fetchProdutos(for: term)
        fetchCategorias(for: term)
        fetchEmpresas(for: term)
    }
    
    fileprivate func fetchProdutos(for term: String) {
        let param = [""]
    }
    
    fileprivate func fetchCategorias(for term: String) {
        
    }
    
    fileprivate func fetchEmpresas(for term: String) {
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return produtos.count
        case 2: return empresas.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        
        var text: String?
        
        switch indexPath.section {
        case 1: text = produtos[indexPath.item].nome
        case 2: text = empresas[indexPath.item].nome
        default: break
        }
        
        cell.textLabel?.text = text

        return cell
    }
}

extension MainResultsTableController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchString = searchController.searchBar.text else { return }
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchString.trimmingCharacters(in: whitespaceCharacterSet)
        
        fetchRemoteData(for: strippedString)
    }
}
