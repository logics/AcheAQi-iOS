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
    
    var cardNumber: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var titular: String = "" {
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
        let color4 = UIColor(red: 0.343, green: 0.457, blue: 0.482, alpha: 1.000)

        
        //// Subframes
        let group: CGRect = CGRect(x: frame.minX, y: frame.minY, width: fastFloor((frame.width) * 1.00000 + 0.5), height: fastFloor((frame.height) * 1.00000 + 0.5))
        
        
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
        let rectangle3Rect = CGRect(x: group.minX + fastFloor(group.width * 0.06000 + 0.5), y: group.minY + fastFloor(group.height * 0.51220 + 0.5), width: fastFloor(group.width * 0.77143 + 0.5) - fastFloor(group.width * 0.06000 + 0.5), height: fastFloor(group.height * 0.63902 + 0.5) - fastFloor(group.height * 0.51220 + 0.5))
        let rectangle3Path = UIBezierPath(rect: rectangle3Rect)
        color3.setFill()
        rectangle3Path.fill()
        let rectangle3TextContent = cardNumber
        let rectangle3Style = NSMutableParagraphStyle()
        rectangle3Style.alignment = .center
        let rectangle3FontAttributes = [
            .font: UIFont.systemFont(ofSize: labelFontSize),
            .foregroundColor: color2,
            .paragraphStyle: rectangle3Style,
        ] as [NSAttributedString.Key: Any]
        
        let rectangle3Inset: CGRect = rectangle3Rect.insetBy(dx: 5, dy: 0)
        let rectangle3TextHeight: CGFloat = rectangle3TextContent.boundingRect(with: CGSize(width: rectangle3Inset.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: rectangle3FontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: rectangle3Inset)
        rectangle3TextContent.draw(in: CGRect(x: rectangle3Inset.minX, y: rectangle3Inset.minY + (rectangle3Inset.height - rectangle3TextHeight) / 2, width: rectangle3Inset.width, height: rectangle3TextHeight), withAttributes: rectangle3FontAttributes)
        context.restoreGState()
        
        
        //// Rectangle 4 Drawing
        let rectangle4Rect = CGRect(x: group.minX + fastFloor(group.width * 0.81429 + 0.5), y: group.minY + fastFloor(group.height * 0.51220 + 0.5), width: fastFloor(group.width * 0.94000 + 0.5) - fastFloor(group.width * 0.81429 + 0.5), height: fastFloor(group.height * 0.63902 + 0.5) - fastFloor(group.height * 0.51220 + 0.5))
        let rectangle4Path = UIBezierPath(rect: rectangle4Rect)
        color3.setFill()
        rectangle4Path.fill()
        let rectangle4TextContent = cvv
        let rectangle4Style = NSMutableParagraphStyle()
        rectangle4Style.alignment = .center
        let rectangle4FontAttributes = [
            .font: UIFont.italicSystemFont(ofSize: cvvFontSize),
            .foregroundColor: UIColor.black,
            .paragraphStyle: rectangle4Style,
        ] as [NSAttributedString.Key: Any]
        
        let rectangle4TextHeight: CGFloat = rectangle4TextContent.boundingRect(with: CGSize(width: rectangle4Rect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: rectangle4FontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: rectangle4Rect)
        rectangle4TextContent.draw(in: CGRect(x: rectangle4Rect.minX, y: rectangle4Rect.minY + (rectangle4Rect.height - rectangle4TextHeight) / 2, width: rectangle4Rect.width, height: rectangle4TextHeight), withAttributes: rectangle4FontAttributes)
        context.restoreGState()
        
        
        //// Text Drawing
        let textRect = CGRect(x: group.minX + fastFloor(group.width * 0.81429 + 0.5), y: group.minY + fastFloor(group.height * 0.40488 + 0.5), width: fastFloor(group.width * 0.94000 + 0.5) - fastFloor(group.width * 0.81429 + 0.5), height: fastFloor(group.height * 0.50732 + 0.5) - fastFloor(group.height * 0.40488 + 0.5))
        let textTextContent = "CVV"
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [
            .font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
            .foregroundColor: color2,
            .paragraphStyle: textStyle,
        ] as [NSAttributedString.Key: Any]
        
        let textTextHeight: CGFloat = textTextContent.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        textTextContent.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()
        
        
        //// Text 2 Drawing
        let text2Rect = CGRect(x: group.minX + fastFloor(group.width * 0.06000 + 0.5), y: group.minY + fastFloor(group.height * 0.70244 + 0.5), width: fastFloor(group.width * 0.94000 + 0.5) - fastFloor(group.width * 0.06000 + 0.5), height: fastFloor(group.height * 0.80488 + 0.5) - fastFloor(group.height * 0.70244 + 0.5))
        let text2TextContent = titular.uppercased()
        let text2Style = NSMutableParagraphStyle()
        text2Style.alignment = .left
        let text2FontAttributes = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: color4,
            .paragraphStyle: text2Style,
        ] as [NSAttributedString.Key: Any]
        
        let text2TextHeight: CGFloat = text2TextContent.boundingRect(with: CGSize(width: text2Rect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: text2FontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: text2Rect)
        text2TextContent.draw(in: CGRect(x: text2Rect.minX, y: text2Rect.minY + (text2Rect.height - text2TextHeight) / 2, width: text2Rect.width, height: text2TextHeight), withAttributes: text2FontAttributes)
        context.restoreGState()
    }
}
