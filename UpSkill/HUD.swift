//
//  Copyright 2013-2016 Microsoft Inc.
//

import UIKit
import MBProgressHUD

class HUD {
  static func show() {
    showWithTitle(nil)
  }

  static func showWithTitle(title: String?) {
    if let lastWindow = UIApplication.sharedApplication().windows.last {
      let hud = MBProgressHUD.showHUDAddedTo(lastWindow, animated: true)
      hud.labelText = title
    }
  }

  static func hide() {
    let lastWindow = UIApplication.sharedApplication().windows.last
    MBProgressHUD.hideHUDForView(lastWindow, animated: true)
  }
}
