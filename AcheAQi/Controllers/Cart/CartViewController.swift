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
    
    // Models
    var vlrTotal: Float = 0.0 {
        didSet {
            totalLabel.text = self.vlrTotal.toCurrency()
        }
    }
    var cart: Cart {
        return cartFetchedResultsController.fetchedObjects?.first ?? Cart(context: self.moc)
    }
    
    private lazy var moc: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    fileprivate lazy var cartFetchedResultsController: NSFetchedResultsController<Cart> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Cart.createdAt, ascending: false)]
        fetchRequest.fetchLimit = 1
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    fileprivate lazy var itemsFetchedResultsController: NSFetchedResultsController<CartItem> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.predicate = NSPredicate(format: "cart == %@", self.cart)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CartItem.addedAt, ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    // MARK: - Private Methods
    
    private func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                let item = itemsFetchedResultsController.object(at: indexPath)
                (cell as! CartProdutoCell).item = item
            case 1:
                (cell as! CartPaymentMethodCell).cart = cart
            case 2:
                (cell as! CartShippingMethodCell).cart = cart
            default:
                fatalError()
        }
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
            item.valorUnitario = produto.valor
            item.addedAt = Date()
            item.qtd = Int16(qtd)
            
            cart.addToItems(item)
            
            context.saveObject()
        }
    }
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try cartFetchedResultsController.performFetch()
            try itemsFetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        view.blur(blurRadius: 0.98)
        
        itemsFetchedResultsController.fetchedObjects?.forEach({ item in
            self.vlrTotal += item.valorUnitario * Float(item.qtd)
        })
    }
    
    // MARK: - IBActions
    @IBAction func avancar(_ sender: Any) {
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

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return itemsFetchedResultsController.fetchedObjects?.count ?? 0
            case 1, 2:
                return 1
                
            default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: productCellID, for: indexPath) as! CartProdutoCell
                let item = itemsFetchedResultsController.object(at: indexPath)
                
                cell.item = item
                
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
        if section > 0 { return nil }
        
        let view = tableView.dequeueReusableCell(withIdentifier: sectionCellID)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? CGFloat(0.0) : CGFloat(40)
    }
}

extension CartViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .automatic)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .automatic)
            case .update:
                let cell = tableView.cellForRow(at: indexPath!)!
                configure(cell: cell, at: indexPath!)
            case .move:
                tableView.deleteRows(at: [indexPath!], with: .automatic)
                tableView.insertRows(at: [newIndexPath!], with: .automatic)
            @unknown default:
                print("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
