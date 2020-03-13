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
    var resultsController: MainResultsTableController!
    var produtos: [Produto] = []
    var filters = Filters()
    var currentLocation: CLLocationCoordinate2D?
    var isUpdatingLocation: Bool = false
    var produtoSelected: Produto?
    
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
    
    // MARK: Private Functions
    
    private func setupSearchBar() {
        
        resultsController = self.storyboard?.instantiateViewController(withIdentifier: "MainResultsTableController") as? MainResultsTableController
        resultsController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        let searchBar = searchController.searchBar
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.backgroundColor = .white
            textFieldInsideSearchBar.layer.cornerRadius = 18
            textFieldInsideSearchBar.layer.masksToBounds = true
            
            let attrString = NSAttributedString(string: "Informe um produto", attributes: [.foregroundColor: UIColor.white])
            
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
    
    @objc private func fetchRemoteData() {
        var params = [String: Any]()
        
        if filters.count > 0 {
            if filters.useLocation, let location = currentLocation {
                params["order[distance]"] = String(format: "ASC:%ld,%ld", location.latitude, location.longitude)
            }
            
            for categoria in filters.categorias {
                params["categoria.nome[]"] = categoria.nome
            }
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
        let filtroVC = self.storyboard!.instantiateViewController(identifier: "MainFiltroViewController") as! FiltroTableViewController
        filtroVC.filters = self.filters
        filtroVC.filtroDelegate = self
        
        let vc = UINavigationController(rootViewController: filtroVC)
        vc.navigationBar.barTintColor = .clear
        vc.navigationBar.backgroundColor = .clear
        
        vc.modalPresentationStyle = .popover
        
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.permittedArrowDirections = .up
        popover.barButtonItem = sender
        popover.delegate = self
        
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
        
        cell.valorLabel.text = produto.valor.toCurrency() ?? "R$ --,--"
        cell.nomeLabel.text = produto.nome
        
        cell.nomeLabel.sizeToFit()

        cell.imageView.af_setImage(withURL: URL(wsURLWithPath: produto.foto), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
    
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        produtoSelected = produtos[indexPath.item]
        
        performSegue(withIdentifier: segueShowProduto, sender: self)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
        
    /*override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        flowLayout.estimatedItemSize = CGSize(width: (view.bounds.size.width / 2) - 1, height: 10)
        super.traitCollectionDidChange(previousTraitCollection)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        flowLayout.estimatedItemSize = CGSize(width: (view.bounds.size.width / 2) - 1, height: 10)
        flowLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        return cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }*/
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
}


// MARK: - Search Results Delegate

extension MainCollectionViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        // Update the filtered array based on the search text.
        let searchResults = produtos.map { $0.nome }

        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        
        let filteredResults = searchResults.filter { $0.contains(strippedString) }

        // Apply the filtered results to the search results table.
        if let resultsController = searchController.searchResultsController as? MainResultsTableController {
            resultsController.results = filteredResults
            resultsController.tableView.reloadData()
        }
    }
    
    private func findMatches(searchString: String) -> NSCompoundPredicate {
        /** Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
            Example if searchItems contains "Gladiolus 51.99 2001":
                name CONTAINS[c] "gladiolus"
                name CONTAINS[c] "gladiolus", yearIntroduced ==[c] 2001, introPrice ==[c] 51.99
                name CONTAINS[c] "ginger", yearIntroduced ==[c] 2007, introPrice ==[c] 49.98
        */
        var searchItemsPredicate = [NSPredicate]()
        
        /** Below we use NSExpression represent expressions in our predicates.
            NSPredicate is made up of smaller, atomic parts:
            two NSExpressions (a left-hand value and a right-hand value).
        */
        
        // Product title matching.
        let titleExpression = NSExpression(forKeyPath: Produto.ExpressionKeys.nome.rawValue)
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        let titleSearchComparisonPredicate =
        NSComparisonPredicate(leftExpression: titleExpression,
                              rightExpression: searchStringExpression,
                              modifier: .direct,
                              type: .contains,
                              options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(titleSearchComparisonPredicate)
                
        let finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)

        //Swift.debugPrint("search predicate = \(String(describing: finalCompoundPredicate))")
        return finalCompoundPredicate
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
            
        }
        
        print(searchString ?? "")
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
