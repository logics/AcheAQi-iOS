//
//  String+QRBarCode.swift
//  Logics
//
//  Created by Romeu Godoi on 17/12/18.
//  Copyright © 2018 Logics Software. All rights reserved.
//

import UIKit

extension String {
    func generateQRCode() -> UIImage? {
        let data = self.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
