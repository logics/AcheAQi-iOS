//
//  UICollectionViewExtension.swift
//  Logics Software
//
//  Created by Romeu Godoi on 06/03/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    public func beginRefreshing() {
        
        // Make sure that a refresh control to be shown was actually set on the view
        // controller and the it is not already animating. Otherwise there's nothing
        // to refresh.
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else {
            return
        }
        
        // Start the refresh animation
        refreshControl.beginRefreshing()
        
        // Make the refresh control send action to all targets as if a user executed
        // a pull to refresh manually
        refreshControl.sendActions(for: .valueChanged)
        
        // Apply some offset so that the refresh control can actually be seen
        let contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        setContentOffset(contentOffset, animated: true)
    }
    
    public func endRefreshing() {
        refreshControl?.endRefreshing()
    }
}
