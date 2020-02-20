//
//  UITableViewExtension.swift
//  QuadrasNet
//
//  Created by Romeu Godoi on 28/01/19.
//  Copyright © 2019 Logics Software. All rights reserved.
//

import UIKit

extension UITableView {
    
    func adjustFooterViewHeightToFillTableView() {
        
        // Invoke from UITableViewController.viewDidLayoutSubviews()
        
        if let tableFooterView = self.tableFooterView {
            
            let minHeight = tableFooterView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            
            let currentFooterHeight = tableFooterView.frame.height
            
            let fitHeight = self.frame.height - self.adjustedContentInset.top - self.contentSize.height  + currentFooterHeight
            let nextHeight = (fitHeight > minHeight) ? fitHeight : minHeight
            
            if (round(nextHeight) != round(currentFooterHeight)) {
                var frame = tableFooterView.frame
                frame.size.height = nextHeight
                tableFooterView.frame = frame
                self.tableFooterView = tableFooterView
            }
        }
    }
    
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
