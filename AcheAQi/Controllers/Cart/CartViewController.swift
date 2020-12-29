//
//  CartViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 16/11/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import Spring
import CoreData

class CartViewController: UIViewController {

    let segueShowFormaPagamento = "Show Forma Pagamento Segue"

    let sectionCellID = "Section Cell"
    let productCellID = "Product Cell"
    let paymentCellID = "Payment Cell"
    let shippingCellID = "Shipping Cell"

    // Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var btnAvancar: DesignableButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet var emptyView: UIView!
    
    // Models
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    let defaultTableViewBottomSpace: CGFloat = 151.5
    
    var paymentMethodSelected = PaymentMethod.money()
    
    var itemsConfPerSection: Int!

    var vlrTotal: Float = 0.0 {
        didSet {
            totalLabel.text = self.vlrTotal.toCurrency()
        }
    }
    var cart: Cart? {
        return Cart.findPendingOrCreate(context: self.moc)
    }
    
    private lazy var moc: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    fileprivate lazy var itemsFetchedResultsController: NSFetchedResultsController<CartItem> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.predicate = NSPredicate(format: "cart == %@", self.cart ?? Cart())
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CartItem.addedAt, ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try itemsFetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        itemsConfPerSection = countItems() > 0 ? 1 : 0
        
        if let cartaoData = cart?.cartao {
            paymentMethodSelected = PaymentMethod.from(cartaoData: cartaoData)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViews()
    }

    // MARK: - Private Methods
    
    private func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                let item = itemsFetchedResultsController.object(at: indexPath)
                (cell as! CartProdutoCell).item = item
            case 1:
                (cell as! CartPaymentMethodCell).payMethod = paymentMethodSelected
            case 2:
                (cell as! CartShippingMethodCell).cart = cart
            default:
                fatalError()
        }
    }
    
    private func updateViews() {
        if countItems() <= 0 {
            tableView.backgroundView = emptyView
            tableViewBottomConstraint.constant = 0
        } else {
            tableView.backgroundView = nil
            tableViewBottomConstraint.constant = defaultTableViewBottomSpace
        }
        
        self.vlrTotal = 0.0
        
        itemsFetchedResultsController.fetchedObjects?.forEach({ item in
            self.vlrTotal += item.valorUnitario * Float(item.qtd)
        })
    }
    
    private func countItems() -> Int {
        guard let items = itemsFetchedResultsController.fetchedObjects else { return 0 }
        return items.count
    }
    
    // MARK: - Static methods
    static func addProdutoToCart(produto: Produto, qtd: Int, context: NSManagedObjectContext, completionHandler: (() -> Void)? = nil) {
        
        let cart = Cart.findPendingOrCreate(context: context)
            
        if !cart.contains(produtoId: produto.id, context: context) {
            
            var produtoData: Data?
            
            do {
                produtoData = try produto.jsonData()
            } catch {}
            
            let item = NSEntityDescription.insertNewObject(forEntityName: "CartItem", into: context) as! CartItem

            item.produtoId = Int16(produto.id)
            item.produto = produtoData
            item.valorUnitario = produto.valorAtual
            item.addedAt = Date()
            item.qtd = Int16(qtd)
            
            cart.addToItems(item)
            
            context.saveObject()
        }
    }
    
    // MARK: - IBActions
    @IBAction func avancar(_ sender: Any) {
    }
    
    @IBAction func unwindToCartVC(_ unwindSegue: UIStoryboardSegue) {
        
        if let sourceViewController = unwindSegue.source as? PaymentMethodViewController {
            
            self.paymentMethodSelected = sourceViewController.selectedItem
            
            var cartaoData: Data? = nil

            if let cartao = paymentMethodSelected.cartao {
                do {
                    cartaoData = try cartao.jsonData()
                } catch {}
            }
            
            cart?.cartao = cartaoData
            cart?.formaPagamento = paymentMethodSelected.cartao != nil ? "cartao" : "dinheiro"
            
            moc.saveObject()

            tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        }
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueShowFormaPagamento {
            if let nvc = segue.destination as? UINavigationController,
               let vc = nvc.viewControllers.first as? PaymentMethodViewController {
                vc.selectedItem = self.paymentMethodSelected
            }
        }
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                guard let sectionInfo = itemsFetchedResultsController.sections?[section] else { return 0 }
                return sectionInfo.numberOfObjects
            case 1, 2:
                return itemsConfPerSection
                
            default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: productCellID, for: indexPath) as! CartProdutoCell
                let item = itemsFetchedResultsController.object(at: indexPath)
                
                cell.item = item
                cell.delegate = self
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: paymentCellID, for: indexPath) as! CartPaymentMethodCell
                configure(cell: cell, at: indexPath)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: shippingCellID, for: indexPath) as! CartShippingMethodCell
                configure(cell: cell, at: indexPath)
                return cell
            default:
                fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if cell.reuseIdentifier != productCellID {
            guard Login.shared.isLogado else {
                AlertController.showLoginAlert()
                return
            }
        }
        
        cell.animatePop { finished in
            if finished {
                switch cell.reuseIdentifier {
                    case "Payment Cell":
                        self.performSegue(withIdentifier: self.segueShowFormaPagamento, sender: cell)
                    default:
                        break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 || countItems() == 0 { return nil }
        
        let view = tableView.dequeueReusableCell(withIdentifier: sectionCellID)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 || countItems() == 0 ? CGFloat(0.0) : CGFloat(40)
    }
}

extension CartViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                tableView.reloadRows(at: [indexPath!], with: .fade)
            case .move:
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            @unknown default:
                print("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
            case .insert:
                tableView.insertSections(indexSet, with: .fade)
            default:
                tableView.deleteSections(indexSet, with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        /// To fix error when delete a product item, and hide another model's cells
        itemsConfPerSection = countItems() > 0 ? 1 : 0
    }
}

extension CartViewController: CartItemDeletable {
    func deleteCartItem(_ item: CartItem) {
        let cart = item.cart
        
        moc.delete(item)
        moc.saveObject()
        
        if let qtd = itemsFetchedResultsController.fetchedObjects?.count, qtd == 0 {
            moc.delete(cart!)
            moc.saveObject()
        }
        
        tableView.reloadData()
        
        if itemsFetchedResultsController.fetchedObjects?.count == 0 {
            updateViews()
        }
    }
}
