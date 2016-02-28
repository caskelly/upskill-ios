//
//  Copyright 2013-2016 Microsoft Inc.
//

import Foundation

typealias AuthClientSignInCompletionHandler = (() throws -> String?) -> ()
typealias AuthClientSignOutCompletionHandler = (Bool) -> ()

//private let host = "http://www.upskill.us"
private let host = "http://localhost:5000"
private let apiPath = "api/v1"
private let signInPath = "login"
private let signOutPath = "logout"

enum AuthClientError: ErrorType {
  case NonSuccess, NoData, InvalidJSON
}

class AuthClient {

  static func signIn(email: String, password: String, completionHandler: AuthClientSignInCompletionHandler) {
    let signInURL = NSURL(string: "\(host)/\(apiPath)/\(signInPath)")!

    let request = NSMutableURLRequest(URL: signInURL)
    let authString = "\(email):\(password)"
    let authData = authString.dataUsingEncoding(NSUTF8StringEncoding)
    request.setValue("Basic \(authData!.base64EncodedStringWithOptions([]))", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.HTTPMethod = "POST"

    let task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: NSData()) { data, response, error in
      dispatch_async(dispatch_get_main_queue()) {
        if let error = error {
          completionHandler { throw error }
          return
        }

        if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode != 200 {
          completionHandler { throw AuthClientError.NonSuccess }
          return
        }

        if let data = data {
          if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []), dictionary = json as? [String: AnyObject] {
            completionHandler { return dictionary["token"] as? String }
          } else {
            completionHandler { throw AuthClientError.InvalidJSON }
          }
        } else {
          completionHandler { throw AuthClientError.NoData }
        }
      }
    }

    task.resume()
  }

  static func signOut(token: String, completionHandler: AuthClientSignOutCompletionHandler) {
    let signOutURL = NSURL(string: "\(host)/\(apiPath)/\(signOutPath)")!

    let request = NSMutableURLRequest(URL: signOutURL)
    request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
    request.HTTPMethod = "DELETE"

    let task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: NSData()) { data, response, error in
      dispatch_async(dispatch_get_main_queue()) {

        if let _ = error {
          completionHandler(false)
          return
        }

        if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode != 200 {
          completionHandler(false)
          return
        }

        if let data = data {
          if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []), _ = json as? [String: AnyObject] {
            completionHandler(true)
          } else {
            completionHandler(false)
          }
        } else {
          completionHandler(false)
        }
      }
    }

    task.resume()
  }
}
