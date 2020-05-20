//
//  AvatarStroked.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 13/05/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class AvatarStroked: UIControl {
    
    @IBInspectable
    var image: UIImage? {
        didSet {
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var fontSize: CGFloat = 12.0 {
        didSet {
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }

    override func draw(_ rect: CGRect) {
        drawCanvas(frame: rect)
    }

    // This non-generic function dramatically improves compilation times of complex expressions.
    func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }

    func drawCanvas(frame: CGRect = CGRect(x: 0, y: 0, width: 116, height: 116), labelText: String = "Mudar foto") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Color Declarations
        let gradientA0 = UIColor(red: 0.706, green: 0.925, blue: 0.318, alpha: 0.000)
        let gradientA100 = UIColor(red: 0.259, green: 0.576, blue: 0.129, alpha: 1.000)
        let gradientA50 = gradientA100.withAlphaComponent(0.5)
        let gradientA20 = gradientA100.withAlphaComponent(0.2)
        let fillColor = UIColor(red: 0.263, green: 0.263, blue: 0.263, alpha: 0.650)
        let textForeground = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //// Gradient Declarations
        let gradient1 = CGGradient(colorsSpace: nil, colors: [gradientA0.cgColor, gradientA100.cgColor] as CFArray, locations: [0, 1])!
        let gradient2 = CGGradient(colorsSpace: nil, colors: [gradientA0.cgColor, gradientA50.cgColor] as CFArray, locations: [0, 1])!
        let gradient3 = CGGradient(colorsSpace: nil, colors: [gradientA0.cgColor, gradientA20.cgColor] as CFArray, locations: [0, 1])!


        //// Subframes
        let group3: CGRect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)


        //// Group 3
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.91379 * group3.height))
        bezierPath.addCurve(to: CGPoint(x: group3.minX + 0.91379 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.72853 * group3.width, y: group3.minY + 0.91379 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.91379 * group3.width, y: group3.minY + 0.72853 * group3.height))
        bezierPath.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.08621 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.91379 * group3.width, y: group3.minY + 0.27147 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.72853 * group3.width, y: group3.minY + 0.08621 * group3.height))
        bezierPath.addCurve(to: CGPoint(x: group3.minX + 0.08621 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.27147 * group3.width, y: group3.minY + 0.08621 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.08621 * group3.width, y: group3.minY + 0.27147 * group3.height))
        bezierPath.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.91379 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.08621 * group3.width, y: group3.minY + 0.72853 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.27147 * group3.width, y: group3.minY + 0.91379 * group3.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.88793 * group3.height))
        bezierPath.addCurve(to: CGPoint(x: group3.minX + 0.11207 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.28575 * group3.width, y: group3.minY + 0.88793 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.11207 * group3.width, y: group3.minY + 0.71425 * group3.height))
        bezierPath.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.11207 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.11207 * group3.width, y: group3.minY + 0.28575 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.28575 * group3.width, y: group3.minY + 0.11207 * group3.height))
        bezierPath.addCurve(to: CGPoint(x: group3.minX + 0.88793 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.71425 * group3.width, y: group3.minY + 0.11207 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.88793 * group3.width, y: group3.minY + 0.28575 * group3.height))
        bezierPath.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.88793 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.88793 * group3.width, y: group3.minY + 0.71425 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.71425 * group3.width, y: group3.minY + 0.88793 * group3.height))
        bezierPath.close()
        context.saveGState()
        bezierPath.addClip()
        let bezierBounds: CGRect = bezierPath.cgPath.boundingBoxOfPath
        let bezierResizeRatio: CGFloat = min(bezierBounds.width / 96, bezierBounds.height / 96)
        context.drawRadialGradient(gradient1,
            startCenter: CGPoint(x: bezierBounds.midX + -0 * bezierResizeRatio, y: bezierBounds.midY + 6.54 * bezierResizeRatio), startRadius: 0 * bezierResizeRatio,
            endCenter: CGPoint(x: bezierBounds.midX + -0 * bezierResizeRatio, y: bezierBounds.midY + 6.54 * bezierResizeRatio), endRadius: 67.35 * bezierResizeRatio,
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()


        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.95690 * group3.height))
        bezier2Path.addCurve(to: CGPoint(x: group3.minX + 0.95690 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.75234 * group3.width, y: group3.minY + 0.95690 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.95690 * group3.width, y: group3.minY + 0.75234 * group3.height))
        bezier2Path.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.04310 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.95690 * group3.width, y: group3.minY + 0.24766 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.75234 * group3.width, y: group3.minY + 0.04310 * group3.height))
        bezier2Path.addCurve(to: CGPoint(x: group3.minX + 0.04310 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.24766 * group3.width, y: group3.minY + 0.04310 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.04310 * group3.width, y: group3.minY + 0.24766 * group3.height))
        bezier2Path.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.95690 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.04310 * group3.width, y: group3.minY + 0.75234 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.24766 * group3.width, y: group3.minY + 0.95690 * group3.height))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.93103 * group3.height))
        bezier2Path.addCurve(to: CGPoint(x: group3.minX + 0.06897 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.26195 * group3.width, y: group3.minY + 0.93103 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.06897 * group3.width, y: group3.minY + 0.73805 * group3.height))
        bezier2Path.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.06897 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.06897 * group3.width, y: group3.minY + 0.26195 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.26195 * group3.width, y: group3.minY + 0.06897 * group3.height))
        bezier2Path.addCurve(to: CGPoint(x: group3.minX + 0.93103 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.73805 * group3.width, y: group3.minY + 0.06897 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.93103 * group3.width, y: group3.minY + 0.26195 * group3.height))
        bezier2Path.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.93103 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.93103 * group3.width, y: group3.minY + 0.73805 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.73805 * group3.width, y: group3.minY + 0.93103 * group3.height))
        bezier2Path.close()
        context.saveGState()
        bezier2Path.addClip()
        let bezier2Bounds: CGRect = bezier2Path.cgPath.boundingBoxOfPath
        let bezier2ResizeRatio: CGFloat = min(bezier2Bounds.width / 106, bezier2Bounds.height / 106)
        context.drawRadialGradient(gradient2,
            startCenter: CGPoint(x: bezier2Bounds.midX + 0 * bezier2ResizeRatio, y: bezier2Bounds.midY + 2.25 * bezier2ResizeRatio), startRadius: 0 * bezier2ResizeRatio,
            endCenter: CGPoint(x: bezier2Bounds.midX + 0 * bezier2ResizeRatio, y: bezier2Bounds.midY + 2.25 * bezier2ResizeRatio), endRadius: 79.53 * bezier2ResizeRatio,
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()


        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 1.00000 * group3.height))
        bezier3Path.addCurve(to: CGPoint(x: group3.minX + 1.00000 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.77614 * group3.width, y: group3.minY + 1.00000 * group3.height), controlPoint2: CGPoint(x: group3.minX + 1.00000 * group3.width, y: group3.minY + 0.77614 * group3.height))
        bezier3Path.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.00000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 1.00000 * group3.width, y: group3.minY + 0.22386 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.77614 * group3.width, y: group3.minY + 0.00000 * group3.height))
        bezier3Path.addCurve(to: CGPoint(x: group3.minX + 0.00000 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.22386 * group3.width, y: group3.minY + 0.00000 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.00000 * group3.width, y: group3.minY + 0.22386 * group3.height))
        bezier3Path.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 1.00000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.00000 * group3.width, y: group3.minY + 0.77614 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.22386 * group3.width, y: group3.minY + 1.00000 * group3.height))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.97414 * group3.height))
        bezier3Path.addCurve(to: CGPoint(x: group3.minX + 0.02586 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.23814 * group3.width, y: group3.minY + 0.97414 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.02586 * group3.width, y: group3.minY + 0.76186 * group3.height))
        bezier3Path.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.02586 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.02586 * group3.width, y: group3.minY + 0.23814 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.23814 * group3.width, y: group3.minY + 0.02586 * group3.height))
        bezier3Path.addCurve(to: CGPoint(x: group3.minX + 0.97414 * group3.width, y: group3.minY + 0.50000 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.76186 * group3.width, y: group3.minY + 0.02586 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.97414 * group3.width, y: group3.minY + 0.23814 * group3.height))
        bezier3Path.addCurve(to: CGPoint(x: group3.minX + 0.50000 * group3.width, y: group3.minY + 0.97414 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.97414 * group3.width, y: group3.minY + 0.76186 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.76186 * group3.width, y: group3.minY + 0.97414 * group3.height))
        bezier3Path.close()
        context.saveGState()
        bezier3Path.addClip()
        let bezier3Bounds: CGRect = bezier3Path.cgPath.boundingBoxOfPath
        let bezier3ResizeRatio: CGFloat = min(bezier3Bounds.width / 116, bezier3Bounds.height / 116)
        context.drawRadialGradient(gradient3,
            startCenter: CGPoint(x: bezier3Bounds.midX + -0 * bezier3ResizeRatio, y: bezier3Bounds.midY + 2.46 * bezier3ResizeRatio), startRadius: 0 * bezier3ResizeRatio,
            endCenter: CGPoint(x: bezier3Bounds.midX + -0 * bezier3ResizeRatio, y: bezier3Bounds.midY + 2.46 * bezier3ResizeRatio), endRadius: 86.15 * bezier3ResizeRatio,
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()


        //// Group 4
        //// Picture Drawing
        if let image = self.image {
            let pictureRect = CGRect(x: group3.minX + fastFloor(group3.width * 0.13793 + 0.5), y: group3.minY + fastFloor(group3.height * 0.14224) + 0.5, width: fastFloor(group3.width * 0.86207 + 0.5) - fastFloor(group3.width * 0.13793 + 0.5), height: fastFloor(group3.height * 0.86638) - fastFloor(group3.height * 0.14224))
            
            let picturePath = UIBezierPath(ovalIn: pictureRect)
            picturePath.addClip()
            
            image.draw(in: AVMakeRect(aspectRatio: image.size, insideRect: pictureRect))
            
            context.saveGState()
            picturePath.addClip()
            context.translateBy(x: floor(pictureRect.minX + 0.5), y: floor(pictureRect.minY + 0.5))
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -image.size.height)
            context.restoreGState()
        }


        //// Bezier Legend Drawing
        let bezierLegendPath = UIBezierPath()
        bezierLegendPath.move(to: CGPoint(x: group3.minX + 0.49998 * group3.width, y: group3.minY + 0.86638 * group3.height))
        bezierLegendPath.addCurve(to: CGPoint(x: group3.minX + 0.80008 * group3.width, y: group3.minY + 0.70170 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.62554 * group3.width, y: group3.minY + 0.86638 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.73602 * group3.width, y: group3.minY + 0.80088 * group3.height))
        bezierLegendPath.addCurve(to: CGPoint(x: group3.minX + 0.20101 * group3.width, y: group3.minY + 0.70344 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.83707 * group3.width, y: group3.minY + 0.64444 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.16333 * group3.width, y: group3.minY + 0.64582 * group3.height))
        bezierLegendPath.addCurve(to: CGPoint(x: group3.minX + 0.49998 * group3.width, y: group3.minY + 0.86638 * group3.height), controlPoint1: CGPoint(x: group3.minX + 0.26523 * group3.width, y: group3.minY + 0.80164 * group3.height), controlPoint2: CGPoint(x: group3.minX + 0.37516 * group3.width, y: group3.minY + 0.86638 * group3.height))
        bezierLegendPath.close()
        bezierLegendPath.usesEvenOddFillRule = true
        fillColor.setFill()
        bezierLegendPath.fill()


        //// Label Drawing
        let labelRect = CGRect(x: group3.minX + fastFloor(group3.width * 0.25000 + 0.5), y: group3.minY + fastFloor(group3.height * 0.68534) + 0.5, width: fastFloor(group3.width * 0.75000 + 0.5) - fastFloor(group3.width * 0.25000 + 0.5), height: fastFloor(group3.height * 0.78879) - fastFloor(group3.height * 0.68534))
        let labelStyle = NSMutableParagraphStyle()
        labelStyle.alignment = .center


        let labelFontAttributes = [
            .font: UIFont(name: "Helvetica", size: fontSize)!,
            .foregroundColor: textForeground,
            .paragraphStyle: labelStyle,
        ] as [NSAttributedString.Key: Any]


        let labelTextHeight: CGFloat = labelText.boundingRect(with: CGSize(width: labelRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: labelFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: labelRect)
        labelText.draw(in: CGRect(x: labelRect.minX, y: labelRect.minY + (labelRect.height - labelTextHeight) / 2, width: labelRect.width, height: labelTextHeight), withAttributes: labelFontAttributes)
        context.restoreGState()
    }

}
