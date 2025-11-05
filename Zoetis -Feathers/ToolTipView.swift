//
//  ToolTipView.swift
//  ToolTip


import UIKit

enum ToolTipPosition: Int {
    case left
    case right
    case middle
}


class ToolTipView: UIView {
    
    var roundRect:CGRect!
    let toolTipWidth : CGFloat = 20.0
    let toolTipHeight : CGFloat = 12.0
    let tipOffset : CGFloat = 20.0
    var tipPosition : ToolTipPosition = .middle
    
    
    
    convenience init(frame: CGRect, text : String, tipPos: ToolTipPosition){
        self.init(frame: frame)
        self.tipPosition = tipPos
        createLabel(text)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawToolTip(rect)
    }
    
    
    
    func createTipPath(_ rect : CGRect) -> UIBezierPath {
        if tipPosition == .right {
            let tooltipRect = CGRect(x: rect.maxX, y: roundRect.midY , width: toolTipWidth, height: toolTipHeight)
            let trianglePath = UIBezierPath()
            trianglePath.move(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY - 6))
            trianglePath.addLine(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.maxY))
            trianglePath.addLine(to: CGPoint(x: tooltipRect.maxX, y: tooltipRect.midY - 6))
            trianglePath.addLine(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY - 6))
            trianglePath.close()
            return trianglePath
            
        } else {
            let tooltipRect = CGRect(x: rect.midX, y: roundRect.maxY, width: toolTipWidth, height: toolTipHeight)
            let trianglePath = UIBezierPath()
            trianglePath.move(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY))
            trianglePath.addLine(to: CGPoint(x: tooltipRect.maxX, y: tooltipRect.minY))
            trianglePath.addLine(to: CGPoint(x: tooltipRect.midX, y: tooltipRect.maxY))
            trianglePath.addLine(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY))
            trianglePath.close()
            return trianglePath
        }
        
        
    }
    
    func drawToolTip(_ rect : CGRect){
        roundRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: (rect.height - toolTipHeight))
        let roundRectBez = UIBezierPath(roundedRect: roundRect, cornerRadius: 5.0)
        let trianglePath = createTipPath(rect)
        roundRectBez.append(trianglePath)
        let shape = createShapeLayer(roundRectBez.cgPath)
        self.layer.insertSublayer(shape, at: 0)
    }
    
    func createShapeLayer(_ path : CGPath) -> CAShapeLayer{
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.init(red: 0.0/255.0, green: 155.0/255.0, blue: 188.0/255.0, alpha: 1).cgColor
        shape.shadowColor = UIColor.black.withAlphaComponent(0.60).cgColor
        shape.shadowOffset = CGSize(width: 0, height: 2)
        shape.shadowRadius = 5.0
        shape.shadowOpacity = 0.8
        return shape
    }
    
    func createLabel(_ text : String){
        let label = UILabel(frame: CGRect(x: 8, y: 0, width: frame.width, height: frame.height - toolTipHeight))
        label.attributedText = getAttributedRefRange(refRange: text)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        addSubview(label)
    }
    
    func getAttributedRefRange(refRange: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        let messageFont = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 16) ?? UIFont.boldSystemFont(ofSize: 15)]
        let messageAttrString = NSMutableAttributedString(string: refRange, attributes: messageFont)
        
        messageAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, messageAttrString.length))
        return messageAttrString
    }
}
