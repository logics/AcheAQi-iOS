//
//  MainCollectionViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 17/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage

private let reuseIdentifier = "ProdutoCell"
private let headerViewID = "HeaderView"
private let segueShowProduto = "Show Produto Detalhe Segue"

class MainCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var searchController: UISearchController!
    var produtos: [Produto] = []
    var categorias = Categorias()
    var filters = Filters()
    var currentLocation: CLLocationCoordinate2D?
    var isUpdatingLocation: Bool = false
    var produtoSelected: Produto?
    var searchTerm: String = ""
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager
    }()

    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch Categorias
        fetchRemoteCategorias()
        
        // Setup Views
        setupSearchBar()
        setupRefreshControl()
        
        // Reload Data
        collectionView.beginRefreshing()
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
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        let searchBar = searchController.searchBar
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.backgroundColor = UIColor(named: "inputBG")
            textFieldInsideSearchBar.layer.cornerRadius = 18
            textFieldInsideSearchBar.layer.masksToBounds = true
            
            let attrString = NSAttributedString(string: "Procure no AcheAQi", attributes: [.foregroundColor: UIColor.lightGray])
            
            textFieldInsideSearchBar.attributedPlaceholder = attrString
        }
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.titleView = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchRemoteData), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
    }
    
    private func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            locationManager.startUpdatingLocation()
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
        
        isUpdatingLocation = true
    }
    
    private func fetchRemoteCategorias() {
        API.fetchCategorias { response in
            self.categorias = response.result.value ?? Categorias()
        }
    }
    
    @objc private func fetchRemoteData() {
        var params = [String: Any]()
        
        if filters.count > 0 {
            if filters.useLocation, let location = currentLocation {
                params["order[distance]"] = String(format: "ASC:%ld,%ld", location.latitude, location.longitude)
            }
            
            if filters.categorias.count > 0 {
                params["categoria"] = filters.categorias.map { return $0.id }
            }
        }
        
        if searchTerm.count > 2 {
            
            /// Se o usuário já tiver selecionado uma ou mais categorias no Filtro, não precisa usar este termo para filtrar por categoria
            if filters.categorias.count == 0 {
                params["categoria.nome"] = searchTerm
            }
            
            params["nome"] = searchTerm
            params["empresa.nome"] = searchTerm
            params["marca.nome"] = searchTerm
        }
        
        API.fetchProdutos(page: 1, params: params) { response in
            
            if let errorMsg = response.errorMessage {
                AlertController.showAlert(message: errorMsg)
            }
            
            self.produtos = response.result.value ?? Produtos()
            self.collectionView.reloadData()
            
            self.collectionView.endRefreshing()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func openFilter(_ sender: UIBarButtonItem) {
        let filtroVC = self.storyboard!.instantiateViewController(withIdentifier: "MainFiltroViewController") as! FiltroTableViewController
        filtroVC.filters = self.filters
        filtroVC.categorias = self.categorias
        filtroVC.filtroDelegate = self
        
        let vc = UINavigationController(rootViewController: filtroVC)
        vc.navigationBar.barTintColor = UIColor(named: "backgroundNavBar")
        vc.navigationBar.tintColor = .white
        vc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        vc.navigationBar.backgroundColor = UIColor(named: "backgroundNavBar")
        
        vc.modalPresentationStyle = .popover
        
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.permittedArrowDirections = .up
        popover.barButtonItem = sender
        popover.delegate = self
        popover.backgroundColor = UIColor(named: "backgroundNavBar")
        
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueShowProduto:
            let vc = segue.destination as! DetalheViewController
            vc.produto = produtoSelected
            vc.userLocation = currentLocation
        default:
            break
        }
    }
}

// MARK - Collection View Delegate and Datasource
extension MainCollectionViewController {

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return produtos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProdutoCollectionViewCell
    
        let produto = produtos[indexPath.row]
        
        cell.produto = produto
    
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.animatePop(completionHandler: { finished in
            self.produtoSelected = self.produtos[indexPath.item]            
            self.performSegue(withIdentifier: segueShowProduto, sender: self)
        })
    }
}


// MARK: - Filter Delegate

extension MainCollectionViewController: MainFiltroDelegate {
    func didChangeFilters(filters: Filters) {
        self.filters = filters
        
        let badge = filters.count > 0 ? String(filters.count) : nil
        
        self.filterButton.setBadge(text: badge)
        
        if filters.useLocation, isUpdatingLocation == false {
            startMySignificantLocationChanges()
        }
        
        // Update Results
        DispatchQueue.main.async {
            self.collectionView.beginRefreshing()
        }
    }
    
    func didRefresh(categorias: Categorias) {
        self.categorias = categorias
    }
}


// MARK: - Search Results Delegate

extension MainCollectionViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
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

// MARK: - Table View Delegate

extension MainCollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let searchString = cell?.textLabel?.text
        
        searchController.searchBar.resignFirstResponder()
        searchController.searchBar.endEditing(true)
        
        searchController.dismiss(animated: true) {
            self.searchController.searchBar.text = searchString
        }
    }
}

// MARK: - Location Manager Delegate

extension MainCollectionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Falha no LocationManager error:: \(error)")
    }
}
