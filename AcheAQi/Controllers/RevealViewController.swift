//
//  RevealViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 29/05/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

class RevealViewController: UIViewController {

    typealias SplashAnimatableCompletion = () -> Void

    /// The duration of the animation, default to 1.5 seconds. In the case of heartBeat animation recommended value is 3
    open var duration: Double = 1.5
    
    /// The delay of the animation, default to 0.5 seconds
    open var delay: Double = 0.5
    
    open var isShowing: Bool = false
    
    lazy var window: UIWindow? = {
        return UIApplication.shared.keyWindow
    }()

    @IBOutlet weak var logoImageView: UIImageView!
    
    func show(_ completion: @escaping SplashAnimatableCompletion) {
        window?.addSubview(view)
        
        isShowing = true
        
        // Convert a clousure into a block 
        let block: @convention(block) () -> Void = completion
        
        perform(#selector(animateAndClose(_:)), with: block, afterDelay: 2)
    }
    
    @objc func animateAndClose(_ completion: @escaping SplashAnimatableCompletion) {
        
        //Define the shink and grow duration based on the duration parameter
        let shrinkDuration: TimeInterval = duration * 0.3
        
        //Plays the shrink animation
        UIView.animate(withDuration: shrinkDuration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIView.AnimationOptions(), animations: {
            //Shrinks the image
            let scaleTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.75,y: 0.75)
            self.logoImageView.transform = scaleTransform
            
            //When animation completes, grow the image
        }, completion: { finished in
            
            self.playZoomOutAnimation(completion)
        })
    }
    
    /**
     Retuns the default zoom out transform to be use mixed with other transform
     
     - returns: ZoomOut fransfork
     */
    fileprivate func getZoomOutTranform() -> CGAffineTransform
    {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 20, y: 20)
        return zoomOutTranform
    }

    /**
     Plays the zoom out animation with completion
     
     - parameter completion: completion
     */
    func playZoomOutAnimation(_ completion: @escaping SplashAnimatableCompletion)
    {
        if let imageView = logoImageView
        {
            let growDuration: TimeInterval =  duration * 0.3
            
            UIView.animate(withDuration: growDuration, animations:{
                
                imageView.transform = self.getZoomOutTranform()
                self.view.alpha = 0
                
                //When animation completes remote self from super view
            }, completion: { finished in
                
                self.view.removeFromSuperview()
                
                completion()
            })
        }
    }
}
