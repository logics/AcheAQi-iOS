//
//  FiltroTableViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 28/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import Spring

fileprivate let useLocationCellID = "Use Location Cell"
fileprivate let categoriaCellID = "Categoria Cell"

protocol MainFiltroDelegate {
    func didChangeFilters(filters: Filters)
    func didRefresh(categorias: Categorias)
}

class FiltroTableViewController: UITableViewController {
        
    @IBOutlet var bottomBarView: UIView!
    @IBOutlet weak var resetButton: DesignableButton!
    
    var categorias = Categorias()
    var filters = Filters()
    var filtroDelegate: MainFiltroDelegate?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupBottomBar()
        
        super.viewWillAppear(animated)
        
        if categorias.count < 1 {
            // Fetch Remote Data and refresh tableView
            tableView.beginRefreshing()
        }
    }
    
    // MARK: Private Functions

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(fetchRemoteCategorias), for: .valueChanged)
    }
    
    private func setupBottomBar() {
        self.navigationController?.setToolbarHidden(false, animated: true)

        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.toolbar.addSubview(bottomBarView)

        self.navigationController?.toolbar.leadingAnchor.constraint(equalTo: (bottomBarView.leadingAnchor)).isActive = true
        self.navigationController?.toolbar.trailingAnchor.constraint(equalTo: (bottomBarView.trailingAnchor)).isActive = true
        self.navigationController?.toolbar.topAnchor.constraint(equalTo: (bottomBarView.topAnchor)).isActive = true
        self.navigationController?.toolbar.bottomAnchor.constraint(equalTo: (bottomBarView.bottomAnchor)).isActive = true
    }

    @objc private func fetchRemoteCategorias() {
        API.fetchCategorias { response in
            self.categorias = response.result.value ?? Categorias()
            self.filtroDelegate?.didRefresh(categorias: self.categorias)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBAction func didChangeUseLocationSwitch(_ sender: UISwitch) {
        filters.useLocation = sender.isOn
        
        filtroDelegate?.didChangeFilters(filters: self.filters)
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func reset(_ sender: DesignableButton) {
        
        sender.animation = "pop"
        sender.force = 0.4
        
        sender.animateNext {
            self.filters = Filters()
            self.tableView.reloadData()
            
            self.filtroDelegate?.didChangeFilters(filters: self.filters)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return categorias.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: useLocationCellID, for: indexPath) as! UseLocationFilterCell
            cell.useLocation.setOn(self.filters.useLocation, animated: false)
            
            return cell
        case 1:
            let categoria = categorias[indexPath.item]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: categoriaCellID, for: indexPath)
            cell.textLabel?.text = categoria.nome
            cell.accessoryType = filters.categorias.contains(categoria) ? .checkmark : .none
            
            return cell
        default:
            break
        }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            return "Categorias"
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        
        if section == 1 {
            let categoria = categorias[indexPath.item]

            filters.toogleCategoria(categoria)
            
            tableView.reloadData()
        }
        
        filtroDelegate?.didChangeFilters(filters: self.filters)
        
        dismiss(animated: true, completion: nil)
    }
}
