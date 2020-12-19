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
    var produtosCached = Produtos()
    var categorias = Categorias()
    var filters = Filters()
    var currentLocation: CLLocationCoordinate2D?
    var isUpdatingLocation: Bool = false
    var produtoSelected: Produto?
    var searchTerm: String = ""
    var loadingView: LoadingCollectionViewCell?
    var page: Int = 1
    var isLoading: Bool = false
    var isTotalFetched: Bool = false
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager
    }()
    
    lazy var revealVC: RevealViewController = {
        return self.storyboard!.instantiateViewController(withIdentifier: "RevealViewController") as! RevealViewController
    }()
    
    var navBarController: NavigationViewController? {
        return self.navigationController as? NavigationViewController
    }

    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarController?.statusBarStyle = .default
        revealVC.show {
            self.navBarController?.statusBarStyle = .lightContent
        }
        
        // Fetch Categorias
        fetchRemoteCategorias()
        
        // Setup Views
        setupSearchBar()
        setupRefreshControl()
        
        // Reload Data
        collectionView.beginRefreshing()
                
        //Register Loading Reuseable View
        let loadingReusableNib = UINib(nibName: "LoadingCollectionViewCell", bundle: nil)
        collectionView.register(loadingReusableNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: LoadingCollectionViewCell.cellID)
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
        collectionView.setupRefreshControl(self, selector: #selector(resetFlagsAndFetchRemoteData))
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
    
    @objc private func resetFlagsAndFetchRemoteData() {
        resetSearchFlags()
        fetchRemoteData()
    }

    @objc private func fetchRemoteData() {
        
        if isTotalFetched || isLoading { return }
        
        var params = [String: Any]()
        
        if filters.count > 0 {
            if filters.useLocation, let location = currentLocation {
                params["order[distance]"] = String(format: "ASC:%ld,%ld", location.latitude, location.longitude)
            }
            
            if filters.categorias.count > 0 {
                params["categoria"] = filters.categorias.map { return $0.id }
            }
        }
        
        if searchTerm.count > 0 {
            
            /// Se o usuário já tiver selecionado uma ou mais categorias no Filtro, não precisa usar este termo para filtrar por categoria
            if filters.categorias.count == 0 {
                params["categoria.nome"] = searchTerm
            }
            
            params["nome"] = searchTerm
            params["empresa.nome"] = searchTerm
            params["marca.nome"] = searchTerm
        }
        
        isLoading = true
        
        API.fetchProdutos(page: self.page, params: params) { response in
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
            // If is total fetched force collectionView to call referenceSizeForFooterInSection to hide loading
            self.collectionView.setNeedsLayout()
            
            self.collectionView.reloadData()
            self.collectionView.endRefreshing()
            self.isLoading = false
        }
    }
    
    private func resetSearchFlags() {
        page = 1
        isTotalFetched = false
        isLoading = false
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
        let produto = produtos[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProdutoCollectionViewCell
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            loadingView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                          withReuseIdentifier: LoadingCollectionViewCell.cellID,
                                                                          for: indexPath) as? LoadingCollectionViewCell
            loadingView?.activityIndicator.startAnimating()
            
            return loadingView!
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading || self.isTotalFetched {
            return .zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == produtos.count - 10 && !self.isLoading {
            fetchRemoteData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter, !self.isTotalFetched {
            self.loadingView?.activityIndicator.startAnimating()
            
            if !isLoading {
                self.fetchRemoteData()
            }
        } else {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
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
        
        // Reset the search flags to start pagination again
        resetSearchFlags()
        
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
            
            // Reset the search flags to start pagination again
            resetSearchFlags()

            searchTerm = term

            // Search Locally
            self.produtos = produtosCached.filter(term: searchTerm, filters: filters)
            self.collectionView.reloadData()

            if searchTerm.length > 0 {
                // To prevent multiple remote call while the user is typing
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchRemoteData), object: nil)
                self.perform(#selector(fetchRemoteData), with: nil, afterDelay: 0.5)
                
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
        self.produtos = produtosCached.filter(term: searchTerm, filters: filters)
        self.collectionView.reloadData()
        
        self.fetchRemoteData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = ""
        
        resetSearchFlags()
                
        // Search Locally
        self.produtos = produtosCached.filter(term: searchTerm, filters: filters)
        self.collectionView.reloadData()
        self.fetchRemoteData()
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

// MARK: - UIScrollViewDelegate

extension MainCollectionViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading && !isTotalFetched {
            fetchRemoteData()
        }
    }
}
