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
    
    lazy var blurImageView: UIImageView = {
        let imgView = UIImageView(frame: self.view.bounds)
        
        return imgView
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
                
                alert.view.addBlur(radius: 15, from: vc.view)
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
                    self.blurImageView.alpha = 0
                }, completion: { success in
                    if success {
                        self.blurImageView.removeFromSuperview()
                        
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

extension UIView {
    
    func asImage(nonAlphaBackgroundColor: UIColor?) -> UIImage {
        let savedColor = backgroundColor
        let savedCornerRadius = layer.cornerRadius
        layer.cornerRadius = 0
        backgroundColor = nonAlphaBackgroundColor
        
        defer {
            backgroundColor = savedColor
            layer.cornerRadius = savedCornerRadius
        }
        
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
        return renderer.image { _ in self.drawHierarchy(in: bounds, afterScreenUpdates: true) }
    }
    
    func addBlur(radius: Float, from view: UIView? = nil) {
        var bgView = self
        
        if view != nil {
            bgView = view!
        }
        
        let blurImageView = UIImageView(frame: bgView.bounds)
        blurImageView.tag = 2000
        
        blurImageView.image = bgView
            .asImage(nonAlphaBackgroundColor: UIColor(r: 0, g: 0, b: 0, alpha: 1))
            .applyGaussianBlur(radius: radius)
        
        insertSubview(blurImageView, at: 0)
    }
    
    func removeBlur() {
        if let blurView = self.viewWithTag(2000) {
            UIView.animate(withDuration: 0.2) {
                blurView.alpha = 0.0
            } completion: { finished in
                if finished {
                    blurView.removeFromSuperview()
                }
            }
        }
    }
}

import Accelerate

extension UIImage {
    
    // MARK: - Types
    
    private struct BlurComponents {
        
        /// Blur Radius. Mutable proeprty, feel free to change it
        static let GAUSIAN_TO_TENT_RADIUS_RADIO: Float = 8.0
        
        static func arg888format() -> vImage_CGImageFormat {
            return vImage_CGImageFormat(
                bitsPerComponent: 8,
                bitsPerPixel: 32,
                colorSpace: nil,
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue),
                version: 0,
                decode: nil,
                renderingIntent: .defaultIntent
            )
        }
    }
    
    // MARK: - Public Methods
    
    func applyGaussianBlur(radius: Float) -> UIImage {
        assert(radius > 0)
        guard let sourceCgImage = cgImage else { return self }
        
        guard var srcBuffer = createBuffer(sourceImage: sourceCgImage) else { return self }
        let pixelBuffer = malloc(srcBuffer.rowBytes * Int(srcBuffer.height))
        defer { free(pixelBuffer) }
        
        var outputBuffer = vImage_Buffer(
            data: pixelBuffer,
            height: srcBuffer.height,
            width: srcBuffer.width,
            rowBytes: srcBuffer.rowBytes
        )
        
        var boxSize = UInt32(floor(radius * BlurComponents.GAUSIAN_TO_TENT_RADIUS_RADIO))
        boxSize |= 1
        
        let error = vImageTentConvolve_ARGB8888(
            &srcBuffer,
            &outputBuffer,
            nil,
            0, 0,
            boxSize,
            boxSize,
            nil,
            UInt32(kvImageEdgeExtend)
        )
        
        guard error == vImage_Error(kvImageNoError) else { return self }
        
        var format = BlurComponents.arg888format()
        guard
            let cgResult = vImageCreateCGImageFromBuffer(
                &outputBuffer,
                &format,
                nil,
                nil,
                vImage_Flags(kvImageNoFlags),
                nil)
        else { return self }
        
        let result = UIImage(
            cgImage: cgResult.takeRetainedValue(),
            scale: scale,
            orientation: imageOrientation)
        
        return result
    }
    
    // MARK: - Private Methods
    
    private func createBuffer(sourceImage: CGImage) -> vImage_Buffer? {
        var srcBuffer = vImage_Buffer()
        
        var format = BlurComponents.arg888format()
        let error = vImageBuffer_InitWithCGImage(&srcBuffer, &format, nil, sourceImage, vImage_Flags(kvImageNoFlags))
        
        guard error == vImage_Error(kvImageNoError) else { free(srcBuffer.data); return nil }
        return srcBuffer
    }
}
