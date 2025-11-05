//
//  SidePanelViewControllerDelegate.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 07/01/20.
//  Copyright © 2019 . All rights reserved.
//


import Foundation

protocol SidePanelViewControllerDelegate {
    func didSelectLeftPenal(_ selectedRow: Int, selectedDetails: [String:String])
}
