//
//  CVVCardView.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 11/01/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//

import UIKit

@IBDesignable
class CVVCardView: UIView {
    
    var cvv: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var labelFontSize: CGFloat = 12.0
    @IBInspectable var cvvFontSize: CGFloat = 17.0
    @IBInspectable var radius: CGFloat = 15.0

    override func draw(_ rect: CGRect) {
        drawCVVCard(frame: bounds, labelFontSize: labelFontSize, cvvFontSize: cvvFontSize, radius: radius)
    }

    func drawCVVCard(frame: CGRect = CGRect(x: 0, y: 0, width: 350, height: 205), labelFontSize: CGFloat = 12, cvvFontSize: CGFloat = 17, radius: CGFloat = 15) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Color Declarations
        let color = UIColor(red: 0.333, green: 0.694, blue: 0.773, alpha: 1.000)
        let color2 = UIColor(red: 0.380, green: 0.404, blue: 0.459, alpha: 1.000)
        let color3 = UIColor(red: 0.958, green: 0.948, blue: 0.948, alpha: 1.000)
        
        
        //// Subframes
        let group: CGRect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
        
        
        //// Group
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: group.minX + fastFloor(group.width * 0.00000 + 0.5), y: group.minY + fastFloor(group.height * 0.00000 + 0.5), width: fastFloor(group.width * 1.00000 + 0.5) - fastFloor(group.width * 0.00000 + 0.5), height: fastFloor(group.height * 1.00000 + 0.5) - fastFloor(group.height * 0.00000 + 0.5)), cornerRadius: radius)
        color.setFill()
        rectanglePath.fill()
        
        
        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: group.minX + fastFloor(group.width * 0.00000 + 0.5), y: group.minY + fastFloor(group.height * 0.15610 + 0.5), width: fastFloor(group.width * 1.00000 + 0.5) - fastFloor(group.width * 0.00000 + 0.5), height: fastFloor(group.height * 0.34634 + 0.5) - fastFloor(group.height * 0.15610 + 0.5)))
        color2.setFill()
        rectangle2Path.fill()
        
        
        //// Rectangle 3 Drawing
        let rectangle3Rect = CGRect(x: group.minX + fastFloor(group.width * 0.06000 + 0.5), y: group.minY + fastFloor(group.height * 0.43902 + 0.5), width: fastFloor(group.width * 0.77143 + 0.5) - fastFloor(group.width * 0.06000 + 0.5), height: fastFloor(group.height * 0.56585 + 0.5) - fastFloor(group.height * 0.43902 + 0.5))
        let rectangle3Path = UIBezierPath(rect: rectangle3Rect)
        color3.setFill()
        rectangle3Path.fill()
        let rectangle3TextContent = "CVV"
        let rectangle3Style = NSMutableParagraphStyle()
        rectangle3Style.alignment = .right
        let rectangle3FontAttributes = [
            .font: UIFont.systemFont(ofSize: labelFontSize),
            .foregroundColor: UIColor.black,
            .paragraphStyle: rectangle3Style,
        ] as [NSAttributedString.Key: Any]
        
        let rectangle3Inset: CGRect = rectangle3Rect.insetBy(dx: 5, dy: 0)
        let rectangle3TextHeight: CGFloat = rectangle3TextContent.boundingRect(with: CGSize(width: rectangle3Inset.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: rectangle3FontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: rectangle3Inset)
        rectangle3TextContent.draw(in: CGRect(x: rectangle3Inset.minX, y: rectangle3Inset.minY + (rectangle3Inset.height - rectangle3TextHeight) / 2, width: rectangle3Inset.width, height: rectangle3TextHeight), withAttributes: rectangle3FontAttributes)
        context.restoreGState()
        
        
        //// Rectangle 4 Drawing
        let rectangle4Rect = CGRect(x: group.minX + fastFloor(group.width * 0.81429 + 0.5), y: group.minY + fastFloor(group.height * 0.43902 + 0.5), width: fastFloor(group.width * 0.94000 + 0.5) - fastFloor(group.width * 0.81429 + 0.5), height: fastFloor(group.height * 0.56585 + 0.5) - fastFloor(group.height * 0.43902 + 0.5))
        let rectangle4Path = UIBezierPath(rect: rectangle4Rect)
        color3.setFill()
        rectangle4Path.fill()
        let rectangle4TextContent = cvv
        let rectangle4Style = NSMutableParagraphStyle()
        rectangle4Style.alignment = .center
        let rectangle4FontAttributes = [
            .font: UIFont.systemFont(ofSize: cvvFontSize),
            .foregroundColor: UIColor.black,
            .paragraphStyle: rectangle4Style,
        ] as [NSAttributedString.Key: Any]
        
        let rectangle4TextHeight: CGFloat = rectangle4TextContent.boundingRect(with: CGSize(width: rectangle4Rect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: rectangle4FontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: rectangle4Rect)
        rectangle4TextContent.draw(in: CGRect(x: rectangle4Rect.minX, y: rectangle4Rect.minY + (rectangle4Rect.height - rectangle4TextHeight) / 2, width: rectangle4Rect.width, height: rectangle4TextHeight), withAttributes: rectangle4FontAttributes)
        context.restoreGState()
    }

}
