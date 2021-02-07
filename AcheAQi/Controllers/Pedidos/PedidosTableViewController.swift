//
//  PedidosTableViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 05/02/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//

import UIKit

class PedidosTableViewController: UITableViewController {
    
    let itemCellID = "Pedido Item Cell"
    let loadingCellID = LoadingTableViewCell.cellID
    
    var totalCount: Int = 0
    var completelyFetched = false
    var pedidoSelected: Pedido?
    let pageInteractor: PageInteractor<Pedido, Int> = PageInteractor(firstPage: 1, keyPath: \Pedido.id!)

    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setupRefreshControl(self, selector: #selector(refreshAll))
        setupPageInteractor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private Methods
    
    @objc private func refreshAll() {
        pageInteractor.refreshPage()
    }
    
    func setupPageInteractor() {
        // Require to provide instance of TableView/CollectionView
        pageInteractor.pageDelegate = self.tableView
        
        // NetworkManager is implementing PageableService protocol
        pageInteractor.service = self
        pageInteractor.refreshPage()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageInteractor.visibleRow()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Fetch a cell of the appropriate type.
        if indexPath.row >= pageInteractor.count() {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: loadingCellID, for: indexPath) as! LoadingTableViewCell
            
            if indexPath.row < totalCount {
                loadingCell.activityIndicator.startAnimating()
            } else {
                loadingCell.activityIndicator.stopAnimating()
            }
            
            return loadingCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: itemCellID, for: indexPath) as! PedidoTableViewCell
            let cellData = pageInteractor.item(for: indexPath.row)
            // Configure the cell’s contents.
            cell.pedido = cellData
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pedidoSelected = pageInteractor.item(for: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        pageInteractor.shouldPrefetch(index: indexPath.row)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension PedidosTableViewController: PageableService {
    func loadPage<Pedido>(_ page: Int, completion: @escaping (PageInfo<Pedido>?) -> Void) where Pedido : Decodable {
        
        guard !completelyFetched else {
            completion(nil)
            
            return
        }
        
        API.fetchPedidos(page: page) { response in
            
            guard response.result.isSuccess, let items = response.result.value as? [Pedido] else {
                AlertController.showAlert(message: response.errorMessage ?? Constants.defaultAPIErrorMsg)
                return
            }
            
            self.totalCount = response.totalCount ?? 0
            
            self.completelyFetched = self.pageInteractor.count() + items.count == self.totalCount
            
            let info: PageInfo<Pedido> = PageInfo(types: items, page: page, totalPageCount: self.totalCount)
            
            completion(info)
        }
    }
    
    func cancelAllRequests() {
        completelyFetched = false
    }
}
