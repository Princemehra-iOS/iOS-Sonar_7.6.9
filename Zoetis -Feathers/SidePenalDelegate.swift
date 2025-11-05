//
//  SidePenalDelegate.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 07/01/20.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

@objc
protocol SidePenalDelegate {
  @objc optional func toggleLeftPanel()
  @objc optional func toggleRightPanel()
  @objc optional func collapseSidePanels()
}
