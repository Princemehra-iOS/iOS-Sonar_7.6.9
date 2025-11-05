//
//  PECommonResorces.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 27/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit
private var gradientLayerNew: CAGradientLayer?
@IBDesignable

public class PEFormLabel: UILabel {
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureLabel()
    }
    
    func configureLabel() {
        font = UIFont(name: ZoetisArt.HelveticaNeueFont.bold, size: ZoetisArt.FontSize.regular)
        textColor = ZoetisArt.Color.black
    }
    
    
    func addLabelWithAstric(placeHolder:String){
        let passwordAttriburedString = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        let asterix = NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        passwordAttriburedString.append(asterix)
        self.attributedText = passwordAttriburedString;
    }
    
    
    
    
}


@IBDesignable
public class PEFormTextfield: UITextField {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureTF()
    }
    
    @objc public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureTF()
    }
    
    func configureTF() {
        self.font = UIFont(name: ZoetisArt.HelveticaNeueFont.regular, size: ZoetisArt.FontSize.regular)
        textColor = ZoetisArt.Color.black
    }
    
    
}

@IBDesignable
public class PESubmitButton: UIButton {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureButton()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureButton()
        
    }
    
    func configureButton() {
        let myBlueColor = (UIColor(red: 0.0, green: 200.0, blue: 226.0, alpha: 1.0))
        let blue1 = ZoetisArt.ColorCode.blue1
        let blue2 = ZoetisArt.ColorCode.blue2
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors =
        [blue1.cgColor,blue2.cgColor]
        //Use diffrent colors
        self.layer.addSublayer(gradientLayer)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderColor = myBlueColor.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        titleLabel?.font =  UIFont(name: ZoetisArt.HelveticaNeueFont.bold, size: ZoetisArt.FontSize.extraLarge)
        titleLabel?.text = "SIGN IN"
        
        // self.addSubview(button)
    }
    
    func shadowButton(btn:UIButton){
        
        btn.layer.cornerRadius = 6.0
        btn.layer.masksToBounds = false
        btn.layer.shadowColor = UIColor.blue.cgColor;
        btn.layer.shadowOffset = CGSize(width: 0,height: 5.0)
        btn.layer.shadowRadius = 0.0
        btn.layer.shadowOpacity = 1.0
        btn.layer.shouldRasterize = true
    }
    
}


@IBDesignable
public class ZoetisLoginTF: UITextField {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setRoundEdge()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setRoundEdge()
    }
    
    
    func setRoundEdge() {
        let myBlueColor = (UIColor(red: 204.0, green: 227.0, blue: 255.0, alpha: 1.0))
        //Width of border
        self.layer.borderWidth = 1.0
        //How much the edge to be rounded
        self.layer.cornerRadius = self.frame.height/2
        
        // following properties are optional
        //color for border
        self.layer.borderColor = myBlueColor.cgColor
        //color for text
        //self.textColor = UIColor.red
        // Mask the bound
        self.layer.masksToBounds = true
        //clip the pixel contents
        self.clipsToBounds = true
        
        self.setLeftPaddingPoints(10)
    }
}

@IBDesignable
public class ZoetisLoginButton: UIButton {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setRoundAndShadow()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setRoundAndShadow()
    }
    
    func setRoundAndShadow() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
    }
}


// Get Color From RGB
extension UIColor{
    class func getUIColorWithRGB(_ r:CGFloat, g:CGFloat, b:CGFloat)->UIColor{
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0);
    }
    
    class func getStatusColor()->UIColor{
        return UIColor(red: 158.0/255.0, green: 56.0/255.0, blue: 0/255.0, alpha: 1.0);
    }
    class func getLoginBoxColor()->UIColor{
        return UIColor(red: 252.0/255.0, green: 219.0/255.0, blue: 207/255.0, alpha: 1.0);
    }
    class func getGradientUpperColor()->UIColor{
        return UIColor(red: 238.0/255.0, green: 247.0/255.0, blue: 1.0, alpha: 1.0);
    }
    class func getGradientUpperColorStartAssessment()->UIColor{
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
    }
    class func getGradientUpperColorStartAssessmentMid()->UIColor{
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
    }
    class func getGradientUpperColorStartAssessmentLast()->UIColor{
        return UIColor(red: 210.0/255.0, green: 231.0/255.0, blue: 1.0, alpha: 1.0);
    }
    class func getGradientLowerColor()->UIColor{
        return UIColor(red: 207.0/255.0, green: 225.0/255.0, blue: 242/255.0, alpha: 1.0);
    }
    
    class func cellAlternateBlueCOlor()->UIColor{
        return UIColor(red:232.0/255.0, green: 239.0/255.0, blue: 249/255.0, alpha: 1.0);
    }
    
    class func getTextViewBorderColor()->UIColor{
        return UIColor(red: 204.0/255.0, green: 227.0/255.0, blue: 1.0, alpha: 1.0);
    }
    class func getTextViewBorderColorStartAssessment()->UIColor{
        return UIColor(red: 15.0/255.0, green: 117.0/255.0, blue: 187/255.0, alpha: 1.0);
    }
    class func getTextViewBorderColorRefrigatorStartAssessment()->UIColor{
        return UIColor(red: 15.0/255.0, green: 117.0/255.0, blue: 187/255.0, alpha: 0.5);
    }
    class func getNextBtnColorUpper()->UIColor{
        return UIColor(red: 28.0/255.0, green: 157.0/255.0, blue: 245/255.0, alpha: 0.0);
    }
    class func getNextBtnColorLower()->UIColor{
        return UIColor(red:15.0/255.0, green: 117.0/255.0, blue: 187/255.0, alpha: 1.0);
    }
    class func getloginBtnBorderColor()->UIColor{
        return UIColor(red:204.0/255.0, green: 227.0/255.0, blue: 1.0, alpha: 1.0);
    }
    class func getSyncWebBtnColorUpper()->UIColor{
        return UIColor(red: 28.0/255.0, green: 157.0/255.0, blue: 245/255.0, alpha: 0.0);
    }
    class func getSyncWebBtnColorLower()->UIColor{
        return UIColor(red: 0.0/255.0, green: 176.0/255.0, blue: 206.0/255.0, alpha: 1.0);
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIView {

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        let gradientLayer = CAGradientLayer()
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 1)
        } else {
            
        }
    }
    
    func setGradientcheck(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        // Remove existing gradient layers
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    
    
    func setGradientNew(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        
        
        if gradientLayerNew == nil {
            let newLayer = CAGradientLayer()
            layer.insertSublayer(newLayer, at: 0)
            gradientLayerNew = newLayer
        }
        
        if let topColor = topGradientColor?.cgColor,
           let bottomColor = bottomGradientColor?.cgColor {
            gradientLayerNew?.colors = [topColor, bottomColor]
            gradientLayerNew?.borderColor = layer.borderColor
            gradientLayerNew?.borderWidth = layer.borderWidth
            gradientLayerNew?.cornerRadius = layer.cornerRadius
            gradientLayerNew?.frame = bounds // sets initial frame
        }
    }

    
    
    
    func setGradientThreeColors(topGradientColor: UIColor?, midGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        DispatchQueue.main.async {
            let gradientLayer = CAGradientLayer()
            if let topGradientColor = topGradientColor,let midGradientColor = bottomGradientColor , let bottomGradientColor = bottomGradientColor {
                gradientLayer.frame = self.bounds
                gradientLayer.colors = [topGradientColor.cgColor,midGradientColor.cgColor, bottomGradientColor.cgColor]
                gradientLayer.borderColor = self.layer.borderColor
                gradientLayer.borderWidth = self.layer.borderWidth
                gradientLayer.cornerRadius = self.layer.cornerRadius
                self.layer.insertSublayer(gradientLayer, at: 1)
            } else {
                
            }
        }
    }
    
    func setCornerRadiusFloat(radius:CGFloat){
        DispatchQueue.main.async {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
        }
    }
    
    func setDropdownView() {
        DispatchQueue.main.async {
            self.layer.cornerRadius = 20
            self.layer.masksToBounds = true
            self.layer.borderColor = UIColor.getTextViewBorderColor().cgColor
            self.layer.borderWidth = 2.0
            for subview in self.subviews{
                if let img = subview as? UIImageView{
                    img.image = UIImage(named: "dd")
                }
            }
        }
    }
    
    func setDropdownStartAsessmentView(imageName:String) {
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.white
            self.layer.cornerRadius = 20
            self.layer.masksToBounds = true
            self.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.layer.borderWidth = 2.0
            let superviewCurrent =  self.superview
            if superviewCurrent != nil{
                for subview in superviewCurrent!.subviews {
                    if let img = subview as? UIImageView{
                        img.image = UIImage(named: imageName)
                    }
                }
            }
        }
    }
    
    func setDropdownStartAsessmentViewAsNotSelectable(imageName:String) {
        DispatchQueue.main.async {
            // self.backgroundColor = UIColor.white
            self.layer.cornerRadius = 20
            self.layer.masksToBounds = true
            self.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.layer.borderWidth = 2.0
            let superviewCurrent =  self.superview
            if superviewCurrent != nil{
                for subview in superviewCurrent!.subviews {
                    if let img = subview as? UIImageView{
                        img.image = UIImage(named: imageName)
                    }
                }
            }
        }
    }
    
    func setLoginTextfieldRadiusCorner() {
        DispatchQueue.main.async {
            self.layer.cornerRadius = 30
            self.layer.masksToBounds = true
            self.layer.borderColor = UIColor.getloginBtnBorderColor().cgColor
            self.layer.borderWidth = 1.0
        }
    }
    
    func setNextButtonUI() {
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.frame.height/2
            self.layer.masksToBounds = true
            self.layer.borderColor = UIColor.getTextViewBorderColor().cgColor
            self.layer.borderWidth = 2.0
            self.setGradient(topGradientColor: UIColor.getNextBtnColorUpper(), bottomGradientColor: UIColor.getNextBtnColorLower())
        }
        
    }
    
    func setSyncWebButtonUI() {
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.frame.height/2
            self.layer.masksToBounds = true
            self.layer.borderColor = UIColor.getTextViewBorderColor().cgColor
            self.layer.borderWidth = 2.0
            self.setGradient(topGradientColor: UIColor.getSyncWebBtnColorUpper(), bottomGradientColor: UIColor.getSyncWebBtnColorLower())
        }
        
    }
    
    func setLoginButtonGradientUI() {
        DispatchQueue.main.async {
            self.layer.cornerRadius = 4
            self.layer.masksToBounds = true
            self.layer.borderColor = UIColor.getTextViewBorderColor().cgColor
            self.layer.borderWidth = 2.0
            self.setGradient(topGradientColor: UIColor.getNextBtnColorUpper(), bottomGradientColor: UIColor.getNextBtnColorLower())
        }
    }
}


extension String {
    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }}



extension Array {
    
    mutating func remove(at indexs: [Int]) {
        guard !isEmpty else { return }
        let newIndexs = Set(indexs).sorted(by: >)
        newIndexs.forEach {
            guard $0 < count, $0 >= 0 else { return }
            remove(at: $0)
        }
    }
    
}


extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

extension Date {
    init(ticks: UInt64) {
        self.init(timeIntervalSince1970: Double(ticks)/10_000_000 - 62_135_596_800)
    }
}
