//
//  NavigationViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 15/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import CoreData

class NavigationViewController: UINavigationController {
    
    // MARK: - Views
    lazy var cartButton: UIBarButtonItem = {
        
        let cartImage = UIImage(named: "cart-icon")
        
        let lblBadge = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 15, height: 15))
//        lblBadge.backgroundColor = UIColor.green
        lblBadge.clipsToBounds = true
        lblBadge.layer.cornerRadius = 7
        lblBadge.textColor = UIColor.white
//        lblBadge.font = FontLatoRegular(s: 10)
        lblBadge.textAlignment = .center

        
        let button = UIButton()
        button.setImage(cartImage, for: .normal)
        button.addTarget(self, action: #selector(showCart), for: .touchUpInside)

        
        let cartButton = UIBarButtonItem(customView: button)
        
        return cartButton
    }()
    
    // MARK: - Configs
    var statusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    // MARK: - Models
    
    var cart: Cart? {
        didSet {
            // Clear badge
            cartButton.setBadge(text: nil)
            
            if let count = cart?.items?.count, count > 0 {
                cartButton.setBadge(text: String(count), color: UIColor(named: "cartBadge")!)
            }
        }
    }
    
    private lazy var moc: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()

    
    // MARK: - View Controller life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(mocObjectsDidChange(notification:)),
                                       name: .NSManagedObjectContextDidSave,
                                       object: self.moc)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addCartButtonIfNeeds()
    }
    
    // MARK: - Overrides
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        addCartButtonIfNeeds()
    }
    
    // MARK: - Private methods

    private func addCartButtonIfNeeds() {
        
        if let currentVC = visibleViewController {
            
            if let items = currentVC.navigationItem.rightBarButtonItems {
                if !items.contains(cartButton) {
                    currentVC.navigationItem.rightBarButtonItems?.insert(cartButton, at: 0)
                }
            } else {
                currentVC.navigationItem.rightBarButtonItems = [cartButton]
            }
            
            cart = Cart.findPendingOrCreate(context: moc)
        }
    }
    
    @objc private func showCart() {
        let sb = UIStoryboard(name: "Carrinho", bundle: nil)
        
        guard let cartVC = sb.instantiateInitialViewController() else { return }
        
        present(cartVC, animated: true, completion: nil)
    }
    
    @objc private func mocObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        var isChanged = false
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<CartItem>, inserts.count > 0 {
            isChanged = true
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<CartItem>, updates.count > 0 {
            isChanged = true
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            for item in deletes {
                if item.entity.name == "Cart" || item.entity.name == "CartItem", !isChanged {
                    isChanged = true
                }
            }
        }

        if isChanged {
            cart = Cart.findPending(context: moc)
        }
    }
}
