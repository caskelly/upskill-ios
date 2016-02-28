//
//  Copyright 2013-2016 Microsoft Inc.
//

import Foundation
import Valet

class KeyChainService {
  static let shared = KeyChainService()

  private let valet = VALValet(identifier: "Upskill", accessibility: .WhenUnlocked)!

  func setValue(value: String, forKey key: String) {
    valet.setString(value, forKey: key)
  }

  func getValueForKey(key: String) -> String? {
    return valet.stringForKey(key)
  }

  func deleteKey(key: String) {
    valet.removeObjectForKey(key)
  }

}
