//
//  CustomPrintPageRenderer.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 24/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {
    
    let A4PageWidth: CGFloat = 595.2
    
    let A4PageHeight: CGFloat = 841.8
    
    
    override init() {
        super.init()
        
        // Specify the frame of the A4 page.
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)

        // Set the page frame.
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        
        self.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 10.0, dy: 10.0)), forKey: "printableRect")
        
        self.headerHeight = 0.0
        self.footerHeight = 0.0
    }
    
    
    override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
        
        // Specify the header text.
        let headerText: NSString = ""
        
        // Set the desired font.
        let font = UIFont(name: "AmericanTypewriter-Bold", size: 30.0)
        
        // Specify some text attributes we want to apply to the header text.
        let textAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): font!, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(red: 243.0/255, green: 82.0/255.0, blue: 30.0/255.0, alpha: 1.0), convertFromNSAttributedStringKey(NSAttributedString.Key.kern): 7.5 as AnyObject] as [String : AnyObject]
        
        // Calculate the text size.
        let textSize = getTextSize(headerText as String, font: nil, textAttributes: textAttributes as [String : AnyObject])
        
        // Determine the offset to the right side.
        let offsetX: CGFloat = 20.0
        
        // Specify the point that the text drawing should start from.
        let pointX = headerRect.size.width - textSize.width - offsetX
        let pointY = headerRect.size.height/2 - textSize.height/2
        
        // Draw the header text.
        
        headerText.draw(at: CGPoint(x: pointX, y: pointY), withAttributes: convertToOptionalNSAttributedStringKeyDictionary(textAttributes))
    }
    
    
    override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
        
        let footerText: NSString = "Thank you!"
        
        let font = UIFont(name: "Noteworthy-Bold", size: 14.0)
        let textSize = getTextSize(footerText as String, font: font!)
        
        let centerX = footerRect.size.width/2 - textSize.width/2
        let centerY = footerRect.origin.y + self.footerHeight/2 - textSize.height/2
        let attributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): font!, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255, alpha: 1.0)]
        
        // footerText.draw(at: CGPoint(x: centerX, y: centerY), withAttributes: attributes)
        footerText.draw(at: CGPoint(x: centerX, y: centerY), withAttributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        
    }
    func getTextSize(_ text: String, font: UIFont!, textAttributes: [String: AnyObject]! = nil) -> CGSize {
        let testLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.paperRect.size.width, height: footerHeight))
        if let attributes = textAttributes {
            testLabel.attributedText = NSAttributedString(string: text, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        }
        else {
            testLabel.text = text
            testLabel.font = font!
        }
        
        testLabel.sizeToFit()
        
        return testLabel.frame.size
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
