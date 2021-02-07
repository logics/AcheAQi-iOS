//
//  PerfilViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 22/04/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import Spring
import StoreKit
import MessageUI

fileprivate let editCell = "Edit Profile Cell"
fileprivate let pedidosCell = "Pedidos Cell"
fileprivate let contactCell = "Contact Cell"
fileprivate let deliveryCell = "Delivery Cell"
fileprivate let cardCell = "Card Cell"
fileprivate let logoffCell = "Logoff Cell"

class PerfilViewController: UITableViewController {

    let segueShowDelivery = "Show Delivery Segue"
    let segueShowPaymentMethod = "Show PaymentMethod Segue"
    let segueShowPagamentos = "Show Pagamentos Segue"
    
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
            navigationItem.title = nil
            
            if let imgPath = login.avatarPath, imgPath.length > 0 {
                avatarImageView.af_setImage(withURL: URL(wsURLWithPath: imgPath), imageTransition: .crossDissolve(0.2))
            }
            
            nomeLabel.text = login.nome
            
            navigationController?.navigationBar.shadowImage = nil
            tableView.tableHeaderView?.alpha = 1.0
        } else {
            navigationItem.title = "Perfil"
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
    
    private func templateMessageFeedback() -> String {
        let app = Constants.appName
        let versaoApp = Device.shared.appVersion
        let versaoOS = Device.shared.iosVersion
        let build = Device.shared.buildVersion
        let modelo = Device.shared.deviceModel
        
        let template = "\n\n\n----------------------------\nFavor não editar ou remover os itens abaixo. Eles são importantes para nossa engenharia.\n\nAplicativo: \(app) \nVersão: \(versaoApp) \nBuild: \(build) \nVersão iOS: \(versaoOS) \nModelo Device: \(modelo)"
        
        return template
    }

    private func showFeedbackIfCan() {
        if !MFMailComposeViewController.canSendMail() {
            AlertController.showAlert(title: "Ops!", message: "Seu aparelho não possui nenhuma conta de e-mail configurada ainda. Por favor, entre no app Ajustes, configure uma conta e tente novamente.")
            return
        }
        
        let subject = String(format: "Sugestões Aplicativo %@", Constants.appName)
        
        presentFeedbackVC(message: templateMessageFeedback(), subject: subject, to: [Constants.feedbackEmail])
    }
    
    private func presentFeedbackVC(message: String, subject: String, to recipientList: [String]) {
        let vc = MFMailComposeViewController()
        vc.navigationBar.tintColor = Constants.navBarDefaultColor
        vc.setToRecipients(recipientList)
        vc.setSubject(subject)
        vc.setMessageBody(message, isHTML: false)
        vc.mailComposeDelegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    

    // MARK: - Table view delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Login.shared.isLogado ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.animatePop(completionHandler: { finished in
            if finished {
                switch cell?.reuseIdentifier {
                    case editCell:
                        self.openRegister()
                    case pedidosCell:
                        self.performSegue(withIdentifier: self.segueShowPagamentos, sender: cell)
                    case deliveryCell:
                        self.performSegue(withIdentifier: self.segueShowDelivery, sender: cell)
                    case cardCell:
                        self.performSegue(withIdentifier: self.segueShowPaymentMethod, sender: cell)
                    case contactCell:
                        self.showFeedbackIfCan()
                    case logoffCell:
                        AlertController.showAlert(title: "Sair?",
                                                  message: "Você tem certeza que deseja sair do AcheAQi?",
                                                  style: .normal,
                                                  confirmAction: {
                                                    Login.shared.logoff()
                                                  })
                        
                    default:
                        break
                }
            }
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapShowLoginButton(_ sender: UIButton) {
        sender.animatePop { completed in
            if completed {
                self.showLogin()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case segueShowPaymentMethod:
                if let vc = segue.destination as? PaymentMethodViewController {
                    vc.chooseToCart = false
                }
            case segueShowDelivery:
                if let vc = segue.destination as? DeliveryMethodViewController {
                    vc.chooseToCart = false
                }
            default:
                break
        }
    }
}

// MARK: - RegisterDelegate

extension PerfilViewController: RegisterDelegate {
    func didFinishRegister(success: Bool, username: String?) {
        updateViews()
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension PerfilViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
