//
//  Dropdown.swift
//  SwiftyDropdown
//
//  Created by Ozzie Kirkby on 2015-09-26.
//  Copyright © 2015 kirkbyo. All rights reserved.
//

import UIKit

 protocol DropperDelegate {
    func DropperSelectedRow(_ path: IndexPath, contents: String)
}

typealias WSCompletionBlock = (_ responseData: Route?) ->Void

 class Dropper: UIView {

    static let sharedInstance = Dropper(width: 230, height: 200)

    let TableMenu: UITableView = UITableView()
    var completionBlock1: WSCompletionBlock?

    /**
    Alignment of the dropdown menu compared to the button
    
    - Left: Dropdown is aligned to the left side the corresponding button
    
    - Center: Dropdown is aligned to the center of the corresponding button
    
    - Right: Dropdown is aligned to the right of the corresponding button
    */
     enum Alignment {
        case left, center, right
    }

    /**
     Position of the dropdown, relative to the top or bottom of the button
     
     - Top:    Displayed on the top of the dropdown
     - Bottom: Displayed on bottom of the dropdown
     */
     enum Position {
        case top, bottom
    }

    /**
    The current status of the dropdowns state
    
    - Displayed: The dropdown is visible on screen
    - Hidden: The dropdwon is hidden or offscreen.
    
    */
     enum Status {
        case displayed, hidden, shown
    }

    /**
    Default themes for dropdown menu
    
    - Black: Black theme for dropdown. Black background, white text
    - White: White theme for dropdown. White background, black text
    */
     enum Themes {
        case black(UIColor?), white
    }

    // MARK: - Properties
     var trimCorners: Bool = false /// Automaticly applies border radius of 10 to Dropdown
     var defaultAnimationTime: TimeInterval = 0.1 /// The default time for animations to take
     var delegate: DropperDelegate? /// Delegate Property
     var status: Status = .hidden /// The current state of the view
     var spacing: CGFloat = 3 /// The distance from the button to the dropdown
     var maxHeight: CGFloat? /// The maximum possible height of the dropdown
     var cellBackgroundColor: UIColor? /// Sets the cell background color
     var cellColor: UIColor? /// Sets the cell tint color and text color
     var cellTextSize: CGFloat? /// Sets the size of the text to provided value

    // MARK: - Computed Properties
    /// The items to be dispalyed in the tableview
     var items =  NSArray() {
        didSet {
            refreshHeight()
        }
    }

    /// Height of the Dropdown
     var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = 200 }
    }

    /// Width of the Dropdown
     var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = 230 }
    }

    /// Corner Radius of the Dropdown
     var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set {
            TableMenu.layer.cornerRadius = newValue
            TableMenu.clipsToBounds = true
        }
    }

    /// Theme of dropdown menu (Defaults to White theme)
     var theme: Themes = .white {
        didSet {
            switch theme {
            case .white:
                cellColor = UIColor.black
                cellBackgroundColor = UIColor.white
                border = (1, UIColor.black)
            case .black(let backgroundColor):
                let defaultColor = UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1)
                cellBackgroundColor = backgroundColor ?? defaultColor
                cellColor = UIColor.white
                border = (1, backgroundColor ?? defaultColor)
            }
        }
    }

    /**
    Dropdown border styling
    
    - (width: CGFloat) Border Width
    - (color: UIColor) Color of Border
    
    */
     var border: (width: CGFloat, color: UIColor) {
        get { return (TableMenu.layer.borderWidth, UIColor(cgColor: TableMenu.layer.borderColor!)) }
        set {
            let (borderWidth, borderColor) = newValue
            TableMenu.layer.borderWidth = borderWidth
            TableMenu.layer.borderColor = borderColor.cgColor
        }
    }

    // MARK: - Private Computed Properties
    /// Private property used to determine if the user has set a max height or if no max height is provided then make sure its less then the height of the view
    fileprivate var max_Height: CGFloat {
        get {
            if let height = maxHeight { // Determines if max_height is provided
                return height
            }

            if let containingView = self.superview { // restrict to containing views height
                return containingView.frame.size.height - self.frame.origin.y
            }

            return self.frame.size.height // catch all returns the current height
        }
        set {
            maxHeight = 200
        }
    }

    /// Gets the current root view of where the dropdown is
    fileprivate var root: UIView? {
        guard let current = UIApplication.shared.keyWindow?.subviews.last else {
            //print("[Dropper] &Error:100: Could not find current view. Please report this issue @ https://github.com/kirkbyo/Dropper/issues")
            return nil
        }
        return current
    }

    // MARK: - Layout & Setup
    override  func layoutSubviews() {
        super.layoutSubviews()
        // Size of table menu
        TableMenu.frame.size.height = self.frame.size.height + 0.1
        TableMenu.frame.size.width = self.frame.size.width + 0.1
        // Delegates and data Source
        TableMenu.dataSource = self
        TableMenu.delegate = self
        TableMenu.register(DropperCell.self, forCellReuseIdentifier: "cell")

        TableMenu.layer.cornerRadius = 5
          TableMenu.layer.borderWidth = 1.0
         TableMenu.layer.borderColor = UIColor.lightGray.cgColor
        // Styling
        TableMenu.backgroundColor = UIColor.lightGray
        TableMenu.separatorStyle = UITableViewCell.SeparatorStyle.none
        TableMenu.bounces = false
        if (trimCorners) {
            TableMenu.layer.cornerRadius = 5
            TableMenu.clipsToBounds = true
        }

        //self.superview?.backgroundColor = UIColor.redColor()
    }

    // MARK: - Private Properties
    /// Defines if the view has been shown yet
    fileprivate var shown: Status = .hidden

    // MARK: - Init
     init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {

        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        TableMenu.rowHeight = 50
        TableMenu.layer.borderColor = UIColor.white.cgColor
        TableMenu.layer.borderWidth = 1
        self.superview?.addSubview(self)

        self.tag = 2038 // Year + Month + Day of Birthday. Used to distinguish the dropper from the rest of the views
    }

    convenience  init() {
        self.init()
    }

    convenience  init(width: CGFloat, height: CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }

    required  init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    // MARK: - API

    /**
    Displays the dropdown
    
    - parameter options: Position of the dropdown corresponding of the button
    - parameter button: Button to which the dropdown will be aligned to
    
    */

    /**
    Displays the dropdown
    
    - parameter options:  Vertical alignment of the dropdown corresponding of the button
    - parameter position: Horizontal alignment of the dropdown. Defaults to bottom.
    - parameter button:   Button to which the dropdown will be aligned to
    */
     func show(_ options: Alignment, position: Position = .bottom, button: UIButton) {
        refreshHeight()

        switch options { // Aligns the view vertically to the button
        case .left:
            self.frame.origin.x = button.frame.origin.x
        case .right:
            self.frame.origin.x = button.frame.origin.x + button.frame.width
        case .center:
            self.frame.origin.x = button.frame.origin.x + (button.frame.width - self.frame.width)/2
        }

        switch position { // Aligns the view Horizontally to the button
        case .top:
            self.frame.origin.y = button.frame.origin.y - height - spacing
        case .bottom:
            self.frame.origin.y = button.frame.origin.y + button.frame.height + spacing
        }

        if (!self.isHidden) {
            self.addSubview(TableMenu)
            if let buttonRoot = findButtonFromSubviews((button.superview?.subviews)!, button: button) {
                buttonRoot.superview?.addSubview(self)

            } else {
                if let rootView = root {
                    rootView.addSubview(self)
                }
            }
        } else {
            self.TableMenu.isHidden = false
            self.isHidden = false
        }
        status = .displayed
    }

    /**
    Displays the dropdown with fade in type of aniamtion
    
    - parameter time:    Time taken for the fade animation
    - parameter options: Position of the dropdown corresponding of the button
    - parameter button:  Button to which the dropdown will be aligned to
    */
    func showWithAnimationWithBlocks(_ time: TimeInterval, options: Alignment, position: Position = .bottom, button: UIButton, newItems: NSArray, completionBlock:@escaping WSCompletionBlock) {
        if (self.isHidden) {
            refresh()
            height = self.TableMenu.frame.height
        }
        self.items = newItems
        completionBlock1 = completionBlock
        self.TableMenu.alpha = 0.0
        self.show(options, position: position, button: button)
        UIView.animate(withDuration: time, animations: {
            self.TableMenu.alpha = 1.0
        })
    }

     func showWithAnimation(_ time: TimeInterval, options: Alignment, position: Position = .bottom, button: UIButton) {
        if (self.isHidden) {
            refresh()
            height = self.TableMenu.frame.height
        }
        self.TableMenu.alpha = 0.0
        self.show(options, position: position, button: button)
        UIView.animate(withDuration: time, animations: {
            self.TableMenu.alpha = 1.0
        })
    }

    /**
    Hides the dropdown from the view
    */
     func hide() {
        status = .hidden
        self.isHidden = true
        if shown == .hidden {
            shown = .shown
        }
    }

    /**
    Fades out and hides the dropdown from the view
    
    - parameter time: Time taken to fade out the dropdown
    */
     func hideWithAnimation(_ time: TimeInterval) {
        UIView.animate(withDuration: time, delay: 0.0, options: .curveEaseOut, animations: {
            self.TableMenu.alpha = 0.0
            }, completion: { _ in
                self.hide()
        })
    }

    /**
    Refresh the Tablemenu. For specifically calling .reloadData() on the TableView
    */
     func refresh() {
        TableMenu.reloadData()
    }

    /**
    Refreshes the table view height
    */
    fileprivate func refreshHeight() {
        // Updates the height of the view depending on the amount of item
        let tempHeight: CGFloat = CGFloat(items.count) * TableMenu.rowHeight // Height of TableView
        if (tempHeight <= max_Height) { // Determines if tempHeight is greater then max height
            height = tempHeight
        } else {
            height = 270
        }
    }

    /**
    Find corresponding button to which the dropdown is aligned too
    
    - parameter subviews: All subviews of where the button is.
    - parameter button: Button to find
    
    - returns: Found button or nil
    */
    fileprivate func findButtonFromSubviews(_ subviews: [UIView], button: UIButton) -> UIView? {
        for subview in subviews {
            if (subview is UIButton && subview == button) {
                return button
            }
        }
        return nil
    }
}

extension Dropper: UITableViewDelegate, UITableViewDataSource, DropperExtentsions {
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DropperCell
        // Sets up Cell
        // Removes image and text just in case the cell still contains the view
        cell.imageItem.removeFromSuperview()
        cell.textItem.removeFromSuperview()
        cell.last = items.count - 1  // Sets the last item to the cell
        cell.indexPath = indexPath // Sets index path to the cell
        cell.borderColor = border.color
        var item = String()
        if let skeletaObject = items[indexPath.row] as? Route {
            item = skeletaObject.routeName!
        }

        if let color = cellBackgroundColor {
            cell.backgroundColor = color
        }

        if let color = cellColor {
            cell.textItem.textColor = color
            cell.imageItem.tintColor = color
        }

        if let size = cellTextSize {
            cell.textItem.font = UIFont.systemFont(ofSize: size)
        }

        if let image = toImage(item) { // Determines if item is an image or not
            cell.cellType = .icon
            cell.imageItem.image = image
        } else {
            cell.cellType = .text
            cell.textItem.text = item
        }

        return cell
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //delegate?.DropperSelectedRow(indexPath, contents: items[indexPath.row])
          let skeletaObject: Route = items[indexPath.row] as! Route

        completionBlock1!(skeletaObject )
        self.hideWithAnimation(defaultAnimationTime)
    }
}
