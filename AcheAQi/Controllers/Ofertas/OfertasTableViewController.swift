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
    var produtosCached = Produtos()
    var produtoSelected: Produto?
    var loadingView: LoadingTableViewCell?
    var page: Int = 1
    var isLoading: Bool = false
    var isTotalFetched: Bool = false

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Produtos em oferta"
        
        setupRefreshControl()
        setupSearchBar()
        
        tableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: LoadingTableViewCell.cellID)
        tableView.tableFooterView = UIView()
        
        resetFlagsAndFetchRemoteData()
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
        tableView.setupRefreshControl(self, selector: #selector(resetFlagsAndFetchRemoteData))
    }
    
    @objc private func resetFlagsAndFetchRemoteData() {
        resetSearchFlags()
        fetchRemoteData()
    }
    
    @objc private func fetchRemoteData() {
        
        if isTotalFetched || isLoading {
            return
        }
        
        // Show loading cell
        if !tableView.refreshControl!.isRefreshing, tableView.numberOfRows(inSection: 1) == 0 {
            tableView.beginUpdates()
            tableView.reloadSections([1], with: .automatic)
            tableView.endUpdates()
        }

        var params = [String: Any]()
        
        params["emPromocao"] =  true
        
        if searchTerm.count > 2 {
            params["categoria.nome"] = searchTerm
            params["nome"] = searchTerm
            params["empresa.nome"] = searchTerm
            params["marca.nome"] = searchTerm
        }
        
        isLoading = true
        
        API.fetchProdutos(page: page, params: params) { response in
            
            if let errorMsg = response.errorMessage {
                AlertController.showAlert(message: errorMsg)
            }
            
            let results = response.result.value ?? Produtos()
            
            // If the page is bigger than 1, its
            if self.page == 1 {
                self.produtos = results
            }
            
            for item in results {
                if !self.produtos.contains(item), self.page > 1 {
                    self.produtos.append(item)
                }
                
                if !self.produtosCached.contains(item) {
                    self.produtosCached.append(item)
                }
            }
            
            self.isTotalFetched = self.produtos.count >= (response.totalCount ?? 0)
            
            if !self.isTotalFetched {
                self.page += 1
            }
            self.tableView.reloadData()
            self.tableView.endRefreshing()
            self.isLoading = false
        }
    }
    
    private func resetSearchFlags() {
        page = 1
        isTotalFetched = false
        isLoading = false
    }
    
    private func shouldShowLoadingCell() -> Bool {
        return !self.isLoading && !isTotalFetched
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return produtos.count
        } else {
            return shouldShowLoadingCell() ? 1 : 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let produto = produtos[indexPath.item]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! OfertaCell
            
            cell.produto = produto
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.cellID, for: indexPath) as! LoadingTableViewCell
            cell.activityIndicator.startAnimating()
            cell.backgroundColor = .clear
            
            return cell
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.animatePop(completionHandler: { finished in
            self.produtoSelected = self.produtos[indexPath.item]
            self.performSegue(withIdentifier: segueShowProduto, sender: self)
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 55
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == produtos.count - 10 && !self.isLoading && !isTotalFetched {
            fetchRemoteData()
        }
    }
    
    // MARK: - ScrollView Delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading && page > 1 && !isTotalFetched {
            fetchRemoteData()
        }
    }
}

// MARK: - Search Results Delegate

extension OfertasTableViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let term = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        
        if term != searchTerm {
            
            // Reset the search flags to start pagination again
            resetSearchFlags()

            searchTerm = term

            // Search Locally
            self.produtos = produtosCached.filter(term: searchTerm)
            self.tableView.reloadData()
            
            if searchTerm.length > 0 {
                // To prevent multiple remote call while the user is typing
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(resetFlagsAndFetchRemoteData), object: nil)
                self.perform(#selector(resetFlagsAndFetchRemoteData), with: nil, afterDelay: 0.5)
                
            } else {
                self.fetchRemoteData()
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchTerm == "" {
            searchController.isActive = false
        }
        
        // Search Locally
        self.produtos = produtosCached.filter(term: searchTerm)
        self.tableView.reloadData()

        self.resetFlagsAndFetchRemoteData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = ""
        
        resetSearchFlags()
                
        // Search Locally
        self.produtos = produtosCached.filter(term: searchTerm)
        self.tableView.reloadData()
        self.fetchRemoteData()
    }
}
