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
import Alamofire

enum TipoCompra {
    case carrinho
    case compraDireta
}

class CartViewController: UIViewController {

    let segueShowFormaPagamento = "Show Forma Pagamento Segue"
    let segueShowDeliveryMethod = "Show Address Segue"
    let segueShowCVV = "Show CVV Segue"
    let segueShowFinished = "Show Cart Finished Segue"

    let sectionCellID = "Section Cell"
    let productCellID = "Product Cell"
    let paymentCellID = "Payment Cell"
    let shippingCellID = "Shipping Cell"

    // Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var taxaEntregaLabel: UILabel!
    @IBOutlet weak var btnAvancar: DesignableButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet var emptyView: UIView!
    
    // Models
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    let defaultTableViewBottomSpace: CGFloat = 150
    
    var paymentMethodSelected = PaymentMethod.money()
    var deliveryMethodSelected = DeliveryMethod.retirarPessoalmente()
    
    var itemsConfPerSection: Int!

    var vlrTotal: Float = 0.0 {
        didSet {
            totalLabel.text = self.vlrTotal.toCurrency()
        }
    }
    
    var cart: Cart?
    var pedido: Pedido?
    
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
        
        if cart == nil {
            cart = Cart.findPendingOrCreate(context: self.moc)
        }
        
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
        
        if let endData = cart?.endereco {
            deliveryMethodSelected = DeliveryMethod.from(enderecoData: endData)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        // Capturing Back button action
        if parent == nil {
            self.deleteTmpCart()
        }
    }

    // MARK: - Private Methods
    
    func deleteTmpCart() {
        if let carrinho = cart, carrinho.compraDireta {
            moc.delete(carrinho)
            moc.saveObject()
        }
    }
    
    private func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                let item = itemsFetchedResultsController.object(at: indexPath)
                
                if let cell = cell as? CartProdutoCell {
                    cell.delegate = self
                    cell.item = item
                    cell.tipoCompra = cart!.compraDireta ? .compraDireta : .carrinho
                }
            case 1:
                (cell as! CartPaymentMethodCell).payMethod = paymentMethodSelected
            case 2:
                (cell as! CartShippingMethodCell).deliveryMethod = deliveryMethodSelected
            default:
                fatalError()
        }
    }
    
    private func updateViews() {
        if countItems() <= 0 {
            tableView.backgroundView = emptyView
            tableViewBottomConstraint.constant = -34.5  // Height of the bottom Safe Area, to hide footer too
        } else {
            tableView.backgroundView = nil
            tableViewBottomConstraint.constant = defaultTableViewBottomSpace
        }
        
        self.vlrTotal = 0.0
        
        itemsFetchedResultsController.fetchedObjects?.forEach({ item in
            self.vlrTotal += item.valorUnitario * Float(item.qtd)
        })
        
        if cart?.endereco != nil {
            taxaEntregaLabel.text = cart!.taxaEntrega.toCurrency()
            self.vlrTotal += cart!.taxaEntrega
        } else {
            taxaEntregaLabel.text = Float(0).toCurrency()
        }
        
        
        title = cart!.compraDireta ? "Resumo do Pedido" : "Carrinho de Compra"
        
        let titleAvancar = cart!.compraDireta ? "Finalizar Pedido" : "Continuar a compra"
        btnAvancar.setTitle(titleAvancar, for: .normal)
    }
    
    private func countItems() -> Int {
        guard let items = itemsFetchedResultsController.fetchedObjects else { return 0 }
        return items.count
    }
    
    fileprivate func goToNext() {
        
        if paymentMethodSelected.cartao != nil {
            // Pagamento por cartão
            performSegue(withIdentifier: segueShowCVV, sender: self)
        } else {
            // Pagamento pessoalmente
            registraPedidoWS()
        }
    }
    
    private func registraPedidoWS() {
        
        guard let cart = self.cart else { return }
        
        startAnimating(message: "Criando pedido...")
        
        /// Criando Pedido
        API.savePedido(cart.asPedido(), empresaId: cart.empresaId) { (response: DataResponse<Pedido>) in
            
            self.stopAnimating()
            
            guard response.result.isSuccess, let pedido = response.result.value else {
                let msg = response.errorMessage ?? "Não conseguimos concluir o seu pedido. Por favor tente novamente mais tarde, ou entre em contado com nossa central de atendimento."
                AlertController.showAlert(message: msg)
                return
            }
            
            self.pedido = pedido
                
            self.performSegue(withIdentifier: self.segueShowFinished, sender: self)
        }
    }
    
    // MARK: - Static methods
    static func addProdutoToCart(produto: Produto, qtd: Int, compraDireta: Bool = false, context: NSManagedObjectContext, completionHandler: (() -> Void)? = nil) {
        
        let cart = Cart.findPendingOrCreate(compraDireta: compraDireta, context: context)
            
        if !cart.contains(produtoId: produto.id, context: context),
           (cart.empresaId == 0 || Int(cart.empresaId) == produto.empresa.id) {
            
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
            
            let empresa = produto.empresa
            
            cart.empresaId = Int16(empresa.id)
            cart.taxaEntrega = empresa.taxaEntrega
            
            cart.addToItems(item)
            
            context.saveObject()
        }
        
        if let handler = completionHandler {
            handler()
        }
    }
    
    // MARK: - IBActions
    @IBAction func avancar(_ sender: UIButton) {
        
        guard Login.shared.isLogado else {
            AlertController.showLoginAlert()
            return
        }
        
        sender.animatePop { finished in
            if finished {
                self.goToNext()
            }
        }
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
        else if let sourceViewController = unwindSegue.source as? DeliveryMethodViewController {
            guard let deliveryMethod = sourceViewController.selectedItem else { return }
            
            deliveryMethodSelected = deliveryMethod

            var endData: Data?
            
            if let address = deliveryMethodSelected.endereco {
                do {
                    endData = try address.jsonData()
                } catch {}
            }
            
            cart?.entrega = deliveryMethodSelected.endereco != nil
            cart?.endereco = endData
            
            moc.saveObject()
            
            updateViews()
            
            tableView.reloadSections(IndexSet(integer: 2), with: .fade)
        }
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            case segueShowFormaPagamento:
                if let nvc = segue.destination as? UINavigationController,
                   let vc = nvc.viewControllers.first as? PaymentMethodViewController {
                    vc.selectedItem = self.paymentMethodSelected
                }
                
            case segueShowDeliveryMethod:
                if let nvc = segue.destination as? UINavigationController,
                   let vc = nvc.viewControllers.first as? DeliveryMethodViewController {
                    vc.selectedItem = self.deliveryMethodSelected
                }
                
            case segueShowCVV:
                if let vc = segue.destination as? CVVViewController {
                    vc.cart = cart!
                    vc.cartao = self.paymentMethodSelected.cartao!
                }
                
            case segueShowFinished:
                if let vc = segue.destination as? CartFinishedViewController {
                    vc.pedido = pedido!
                    
                    if let cartTmp = self.cart {
                        self.moc.delete(cartTmp)
                        self.moc.saveObject()
                    }
                }

            default:
                break
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
                
                configure(cell: cell, at: indexPath)
                
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
        
        guard Login.shared.isLogado else {
            AlertController.showLoginAlert()
            return
        }
        
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
                    case self.paymentCellID:
                        self.performSegue(withIdentifier: self.segueShowFormaPagamento, sender: cell)
                    case self.shippingCellID:
                        self.performSegue(withIdentifier: self.segueShowDeliveryMethod, sender: cell)
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
        
        updateViews()
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
    
    func itemUpdated(_ item: CartItem) {
        
    }
}
