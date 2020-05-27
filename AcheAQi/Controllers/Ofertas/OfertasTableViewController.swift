//
//  OfertasTableViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 17/04/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import Alamofire

fileprivate let cellID = "Oferta Cell"
fileprivate let segueShowProduto = "Show Produto Detalhe Segue"

class OfertasTableViewController: UITableViewController {

    var searchController: UISearchController!
    var searchTerm: String = ""
    var produtos: [Produto] = []
    var produtoSelected: Produto?

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Produtos em oferta"
        
        setupRefreshControl()
        setupSearchBar()
        
        tableView.tableFooterView = UIView()
        tableView.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Para corrigir bug na NavBar quando passa de uma com SerchBar para outra que não tem SearchBar na NavBar
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Para corrigir bug na NavBar quando passa de uma com SerchBar para outra que não tem SearchBar na NavBar
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }

    // MARK: - Private Functions
    
    private func setupSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self //resultsController
        searchController.searchBar.autocapitalizationType = .sentences
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        let searchBar = searchController.searchBar
        

        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.backgroundColor = UIColor(named: "inputBG")
            textFieldInsideSearchBar.background = nil
            textFieldInsideSearchBar.layer.cornerRadius = 18
            textFieldInsideSearchBar.layer.masksToBounds = true

            let attrString = NSAttributedString(string: "Procurar ofertas", attributes: [.foregroundColor: UIColor.lightGray])

            textFieldInsideSearchBar.attributedPlaceholder = attrString
        }
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false

        if #available(iOS 13.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchBar
        }
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchRemoteData), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc private func fetchRemoteData() {
        var params = [String: Any]()
        
        params["emPromocao"] =  true
        
        if searchTerm.count > 2 {
            
            params["categoria.nome"] = searchTerm
            params["nome"] = searchTerm
            params["empresa.nome"] = searchTerm
            params["marca.nome"] = searchTerm
        }
        
        API.fetchProdutos(page: 1, params: params) { response in
            
            if let errorMsg = response.errorMessage {
                AlertController.showAlert(message: errorMsg)
            }
            
            self.produtos = response.result.value ?? Produtos()
            self.tableView.reloadData()
            
            self.tableView.endRefreshing()
        }
    }

    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueShowProduto, let produto = produtoSelected {
            let vc = segue.destination as! DetalheViewController
            vc.produto = produto
        }
    }
}

extension OfertasTableViewController {
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let produto = produtos[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! OfertaCell
        
        cell.produto = produto
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.animatePop(completionHandler: { finished in
            self.produtoSelected = self.produtos[indexPath.item]
            self.performSegue(withIdentifier: segueShowProduto, sender: self)
        })
    }
}

// MARK: - Search Results Delegate

extension OfertasTableViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let term = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        
        if term != searchTerm {
            searchTerm = term
            fetchRemoteData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchTerm == "" {
            searchController.isActive = false
        }
    }
}

