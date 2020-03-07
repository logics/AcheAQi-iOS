//
//  AlertViewController.swift
//  Logics Software
//
//  Created by Romeu Godoi on 19/12/18.
//  Copyright © 2018 Logics Software. All rights reserved.
//

import UIKit
import Spring

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
        confirmAction confirm: (() -> ())? = nil,
        okAction okAct: (() -> ())? = nil) {
        
        DispatchQueue.main.async {
            let alert = AlertController(nibName: "Alert", bundle: Bundle.main)
            alert.view.frame = UIScreen.main.bounds
            alert.view.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
            alert.view.translatesAutoresizingMaskIntoConstraints = true
            alert.title = title
            alert.message = message
            alert.centerView.backgroundColor = alert.colorFromStyle(style: style)
            
            alert.confirmAction = confirm
            alert.okAction = okAct
            
            if okAct != nil {
                alert.okButton.addTarget(alert, action: #selector(okHandler), for: .touchUpInside)
            }
            
            if confirm != nil, let okBtn = alert.okButton {
                
                let confirmBtn = GradientButton()
                confirmBtn.isBgGradientColor = true
                confirmBtn.gradientHorizontal = true
                confirmBtn.startColor = UIColor(r:238, g:60, b:23, alpha:1)
                confirmBtn.endColor = UIColor(r:238, g:94, b:23, alpha:1)
                confirmBtn.setTitle("Confirmar", for: .normal)
                confirmBtn.setTitleColor(.white, for: .normal)
                confirmBtn.addTarget(alert, action: #selector(confirmHandler), for: .touchUpInside)
                
                if let stack = okBtn.superview as? UIStackView {
                    stack.insertArrangedSubview(confirmBtn, at: 0)
                }
                
//                okBtn.isBgGradientColor = false
                okBtn.backgroundColor = .white
                okBtn.setTitleColor(.white, for: .normal)
                okBtn.setTitle("Cancelar", for: .normal)
            }

            let window = UIApplication.shared.windows.first
            
            if var vc = window?.rootViewController {
                while let presentedViewController = vc.presentedViewController {
                    vc = presentedViewController
                }
                
                // vc should now be your topmost view controller
                vc.view.addSubview(alert.view)
                vc.addChild(alert)
                vc.didMove(toParent: alert)
            }
        }
    }
    
    func colorFromStyle(style: AlertStyle) -> UIColor {
        switch style {
        case .warning:
            return UIColor.white
        case .error:
            return UIColor(red:1, green:0.149, blue:0, alpha:1)
        default:
            return UIColor.white
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
                }, completion: { success in
                    if success {
                        self.view.removeFromSuperview()
                        self.removeFromParent()
                    }
                })
            }
        }
    }
    
    // MARK: Private Methods
    
    @objc private func confirmHandler() {
        if let handler = confirmAction {
            handler()
        }
        close(self)
    }
    
    @objc private func okHandler() {
        if let handler = confirmAction {
            handler()
        }
        close(self)
    }
}
