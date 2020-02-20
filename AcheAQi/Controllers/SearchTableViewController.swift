//
//  SearchTableViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 13/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UISearchBar {
    var textField: UITextField? {
        
        return subviews.map { $0.subviews.first(where: { $0 is UITextInputTraits}) as? UITextField }
            .compactMap { $0 }
            .first
    }
    
    func changeSearchBarColor(color: UIColor) {
        
        for subView in self.subviews {
            for subSubView in subView.subviews {
                
                if let _ = subSubView as? UITextInputTraits {
                    let textField = subSubView as! UITextField
                    textField.backgroundColor = color
                    break
                }
            }
        }
        
//        UIGraphicsBeginImageContext(self.frame.size)
//        color.setFill()
//        UIBezierPath(rect: self.frame).fill()
//        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        self.setSearchFieldBackgroundImage(bgImage, for: .normal)
    }
}

class SearchTableViewController: UITableViewController {
    
    @IBOutlet weak var headerView: UIView!
    let searchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .white
        
        definesPresentationContext = true
        
//        let view = UIView(frame: headerView.frame)
//        view.backgroundColor = .systemIndigo
//        view.roundCorners(corners: [.bottomLeft], radius: 25)
        
        let searchBar = searchController.searchBar
        searchBar.barTintColor = headerView.backgroundColor
        searchBar.layer.borderColor = UIColor.red.cgColor
        searchBar.setImage(#imageLiteral(resourceName: "searchBarIcon.pdf"), for: .search, state: .normal)
        searchBar.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.6235294118, blue: 0.6745098039, alpha: 1)
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = .white
            textFieldInsideSearchBar.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            textFieldInsideSearchBar.tintColor = .white
            
            let attrString = NSAttributedString(string: "Informe um produto", attributes: [.foregroundColor: UIColor.white])
            
            textFieldInsideSearchBar.attributedPlaceholder = attrString
            
            if let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel {
                textFieldInsideSearchBarLabel.textColor = .white
            }
        }

//        let subtitle = UILabel()
//        subtitle.text = "Procure por Categorias"
//        subtitle.textColor = .white
//        subtitle.font = UIFont.preferredFont(forTextStyle: .title1)
//        subtitle.sizeToFit()
        
        let stack = UIStackView(frame: headerView.frame)
        stack.alignment = .center
        stack.axis = .vertical
        stack.addSubview(searchBar)
//        stack.addSubview(subtitle)
        
        
//        let searchWidth = headerView.frame.width * 0.8
//        searchBar.frame.size.width = searchWidth
//        searchBar.frame.origin.x = (headerView.frame.width - searchWidth) / 2.0
//        searchBar.frame.origin.y = headerView.frame.height - (searchBar.frame.height + 8)
        
        headerView.addSubview(stack)
        
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = UIView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        searchController.searchBar.frame.origin.y = max(0, scrollView.contentOffset.y)
        let searchBar = searchController.searchBar
        var searchBarFrame = searchBar.frame

        if searchController.isActive {
            searchBarFrame.origin.y = 0
        }
        else {
            searchBarFrame.origin.y = max(0, scrollView.contentOffset.y + scrollView.contentInset.top)
        }
        
        searchController.searchBar.frame = searchBarFrame
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
