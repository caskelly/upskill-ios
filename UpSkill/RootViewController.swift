//
//  Copyright 2013-2016 Microsoft Inc.
//

import UIKit

class RootViewController: UINavigationController {

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init() {
    super.init(nibName: nil, bundle: nil)

    navigationBar.translucent = false

    viewControllers = [WebViewController()]
  }
}
