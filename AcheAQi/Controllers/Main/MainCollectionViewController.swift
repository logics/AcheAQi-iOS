//
//  MainCollectionViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 17/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProdutoCell"

class MainCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var searchController: UISearchController!
    var resultsController: MainResultsTableController!

    var produtos: [Produto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        produtos.append(Produto(id: 1,
                                empresa: Empresa(id: 1, nome: "Teste", telefone: "", logomarca: "", cep: "", logradouro: "", cidade: "", bairro: "", numero: 1, complemento: "", estado: "", latitude: 1, longitude: 1, createdAt: "", updatedAt: "", status: true),
                                categoria: Categoria(id: 1, banner: "", nome: "Laser", createdAt: "", updatedAt: ""),
                                nome: "Churrasqueira Steakhouse Grill Polishop",
                                banner: "",
                                createdAt: "",
                                updatedAt: "",
                                foto: "",
                                descricao: "",
                                mostraValor: true,
                                valor: 120.95))
        
        produtos.append(Produto(id: 2,
                                empresa: Empresa(id: 1, nome: "Teste", telefone: "", logomarca: "", cep: "", logradouro: "", cidade: "", bairro: "", numero: 1, complemento: "", estado: "", latitude: 1, longitude: 1, createdAt: "", updatedAt: "", status: true),
                                categoria: Categoria(id: 1, banner: "", nome: "Laser", createdAt: "", updatedAt: ""),
                                nome: "Churrasqueira Elétrica Grill Polishop",
                                banner: "",
                                createdAt: "",
                                updatedAt: "",
                                foto: "",
                                descricao: "",
                                mostraValor: true,
                                valor: 150.99))

    }
    
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
//        searchBar.setImage(#imageLiteral(resourceName: "searchBarIcon.pdf"), for: .search, state: .normal)
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
//            textFieldInsideSearchBar.textColor = .white
            textFieldInsideSearchBar.backgroundColor = .white // UIColor.black.withAlphaComponent(0.3)
//            textFieldInsideSearchBar.tintColor = .white
            textFieldInsideSearchBar.layer.cornerRadius = 18
            textFieldInsideSearchBar.layer.masksToBounds = true
            
            let attrString = NSAttributedString(string: "Informe um produto", attributes: [.foregroundColor: UIColor.white])
            
            textFieldInsideSearchBar.attributedPlaceholder = attrString
            
//            if let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel {
//                textFieldInsideSearchBarLabel.textColor = .white
//                textFieldInsideSearchBarLabel.tintColor = .white
//            }
        }
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.titleView = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK - Collection View Delegate and Datasource
extension MainCollectionViewController {

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return produtos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProdutoCollectionViewCell
    
        let produto = produtos[indexPath.row]
        
        cell.nomeLabel.text = produto.nome
        cell.valorLabel.text = "R$ " + produto.valor.description
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: - UICollectionViewDelegateFlowLayout
        
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let width = CGFloat((collectionView.frame.width / 2))
    //        let height = CGFloat(width * 1.5)
    //
    ////        return CGSize(width: width, height: height)
    //        return CGSize(width: 190.0, height: 228.0)
    //    }

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
