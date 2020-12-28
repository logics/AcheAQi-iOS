//
//  AlertViewController.swift
//  Logics Software
//
//  Created by Romeu Godoi on 19/12/18.
//  Copyright © 2018 Logics Software. All rights reserved.
//

import UIKit
import Spring
import DynamicBlurView

enum AlertStyle {
    case normal
    case warning
    case error
}

class AlertController: UIViewController {

    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var textoLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var confirmButton: GradientButton!
    @IBOutlet weak var centerView: SpringView!
    
    lazy var blurView: DynamicBlurView = {
        let blurredView = DynamicBlurView(frame: self.view.bounds)
        blurredView.blurRadius = 30
        
        return blurredView
    }()

    var confirmAction: (() -> ())?
    var okAction: (() -> ())?

    var message: String? {
        didSet {
            self.textoLabel.text = message
        }
    }
    
    override var title: String? {
        didSet {
            self.tituloLabel.text = title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        
        tituloLabel.text = title
        textoLabel.text = message
    }
    
    class func showAlert(
        title: String = "Ops!",
        message: String,
        style: AlertStyle = .normal,
        isConfirmStyled: Bool = true,
        confirmTitle: String = "Confirmar",
        okTitle: String = "OK",
        confirmAction confirm: (() -> ())? = nil,
        okAction okAct: (() -> ())? = nil) {
        
        DispatchQueue.main.async {
            let alert = AlertController(nibName: "Alert", bundle: Bundle.main)
            alert.view.frame = UIScreen.main.bounds
            alert.view.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
            alert.view.translatesAutoresizingMaskIntoConstraints = true
            alert.title = title
            alert.message = message
            alert.confirmAction = confirm
            alert.okAction = okAct
            alert.okButton.setTitle(okTitle, for: .normal)
            alert.okButton.titleLabel?.font = isConfirmStyled ? .boldSystemFont(ofSize: 17) : .systemFont(ofSize: 17)
            
            let okColor = isConfirmStyled ? alert.colorFromStyle(style: .normal) : alert.colorFromStyle(style: .warning)
            let confirmColor = isConfirmStyled ? alert.colorFromStyle(style: .warning) : alert.colorFromStyle(style: .normal)
            
            alert.okButton.setTitleColor(okColor, for: .normal)
            
            if okAct != nil {
                alert.okButton.addTarget(alert, action: #selector(okHandler), for: .touchUpInside)
            }
            
            if confirm != nil, let okBtn = alert.okButton {
                
                let confirmBtn = UIButton()
//                confirmBtn.isBgGradientColor = true
//                confirmBtn.gradientHorizontal = true
//                confirmBtn.startColor = UIColor(r:238, g:60, b:23, alpha:1)
//                confirmBtn.endColor = UIColor(r:238, g:94, b:23, alpha:1)
//                confirmBtn.backgroundColor = UIColor(named: "systemBackground")
                confirmBtn.backgroundColor = alert.centerView.backgroundColor
                confirmBtn.setTitle(confirmTitle, for: .normal)
                confirmBtn.titleLabel?.font = isConfirmStyled ? .systemFont(ofSize: 17) : .boldSystemFont(ofSize: 17)
                confirmBtn.setTitleColor(confirmColor, for: .normal)
                confirmBtn.addTarget(alert, action: #selector(confirmHandler), for: .touchUpInside)
                
                if let stack = okBtn.superview as? UIStackView {
                    stack.insertArrangedSubview(confirmBtn, at: 0)
                }
            }
            
            if let vc = UIApplication.shared.currentViewController() {
                // vc should now be your topmost view controller
                
                vc.view.addSubview(alert.blurView)
                vc.view.addSubview(alert.view)
                vc.addChild(alert)
                vc.didMove(toParent: alert)
            }
        }
    }
    
    func colorFromStyle(style: AlertStyle) -> UIColor {
        switch style {
        case .warning:
            return UIColor(r:238, g:60, b:23, alpha:1)
        case .error:
            return UIColor(red:1, green:0.149, blue:0, alpha:1)
        case .normal:
            return UIColor.systemBlue
        }
    }

    
    @IBAction func close(_ sender: Any) {
        self.centerView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.view.alpha = 1
        
        UIView.animate(withDuration: 0.2, animations: {
            self.centerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.centerView.alpha = 0.0
        }) { success in
            if success {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.alpha = 0
                    self.blurView.blurRadius = 0
                }, completion: { success in
                    if success {
                        self.blurView.removeFromSuperview()
                        self.view.removeFromSuperview()
                        self.removeFromParent()
                    }
                })
            }
        }
    }
    
    class func showLoginAlert(cancelAction cancelAct: (() -> ())? = nil) {
        AlertController.showAlert(message: "Você precisa efetivar login para prosseguir.\nDeseja ir para a tela de login?",
                                  isConfirmStyled: false,
                                  confirmTitle: "Login",
                                  okTitle: "Cancelar",
                                  confirmAction: {
                                    AlertController.showLoginScreen()
                                  },
                                  okAction: cancelAct)
    }
    
    // MARK: Private Methods
    
    @objc private func confirmHandler() {
        if let handler = confirmAction {
            handler()
        }
        close(self)
    }
    
    @objc private func okHandler() {
        if let handler = okAction {
            handler()
        }
        close(self)
    }
    
    fileprivate class func showLoginScreen() {
        
        guard let loginVC = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController() else { return }
        
        if let vc = UIApplication.shared.currentViewController() {
            vc.present(loginVC, animated: true, completion: nil)
        }
    }
}
