//
//  PerfilViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 22/04/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import Spring

fileprivate let editCell = "Edit Profile Cell"
fileprivate let contactCell = "Contact Cell"
fileprivate let evaluateCell = "Evaluate Cell"
fileprivate let logoffCell = "Logoff Cell"

class PerfilViewController: UITableViewController {

    @IBOutlet var unloggedBgView: UIView!
    @IBOutlet var bgView: CustomView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bgImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var avatarImageView: DesignableImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
    // MARK: - Life Cycle VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: Notification.Name(rawValue: UserDidLogoffNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: Notification.Name(rawValue: UserDidLoginNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViews()
    }
    
    // MARK: - Private methods
    
    @objc private func updateViews() {
        
        let login = Login.shared
        
        if login.isLogado {
            
            if let imgPath = login.avatarPath, imgPath.length > 0 {
                avatarImageView.af_setImage(withURL: URL(wsURLWithPath: imgPath), imageTransition: .crossDissolve(0.2))
            }
            
            nomeLabel.text = login.nome
            
            navigationController?.navigationBar.shadowImage = nil
            tableView.tableHeaderView?.alpha = 1.0
        } else {
            tableView.tableHeaderView?.alpha = 0.0
        }

        tableView.tableFooterView = UIView()
        bgImageViewBottomConstraint.constant = tabBarController?.tabBar.frame.height ?? 0
        
        tableView.backgroundView = login.isLogado ? bgView : unloggedBgView
        tableView.reloadData()
    }
    
    private func showLogin() {
        let loginSB = UIStoryboard(name: "Login", bundle: Bundle.main)
        
        if let vc = loginSB.instantiateInitialViewController() {
            tabBarController?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func openRegister() {
        let loginSB = UIStoryboard(name: "Login", bundle: Bundle.main)
        let vc = loginSB.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        vc.delegate = self
        
        tabBarController?.present(vc, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Login.shared.isLogado ? 1 : 0
    }
    

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        switch cell?.reuseIdentifier {
        case editCell:
            openRegister()
        case logoffCell:
            let alert = UIAlertController(title: "Sair?", message: "Você tem certeza que deseja deslogar do AcheAQi?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { action in
                Login.shared.logoff()
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapShowLoginButton(_ sender: UIButton) {
        sender.animatePop { completed in
            if completed {
                self.showLogin()
            }
        }
    }
}

extension PerfilViewController: RegisterDelegate {
    func didFinishRegister(success: Bool, username: String?) {
        updateViews()
    }
}
