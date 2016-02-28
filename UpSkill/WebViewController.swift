//
//  ViewController.swift
//  UpSkill
//
//  Created by Christopher Skelly on 8/6/15.
//  Copyright (c) 2015 Fourthlock. All rights reserved.
//

import UIKit
import WebKit

//private let rootURL = NSURL(string: "http://www.upskill.us")!
private let rootURL = NSURL(string: "http://localhost:5000")!
private let blankURL = NSURL(string: "about:blank")!

class WebViewController: UIViewController {
  private let webView: UIWebView = {
    let webView = UIWebView()
    webView.scrollView.bounces = false
    webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal

    return webView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "UpSkill"

    webView.delegate = self

    view.addSubview(webView)

    presentSignInOrLoadURL(rootURL)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    webView.frame = view.bounds
  }

  @objc private func didTapSignOut() {
    guard let token = KeyChainService.shared.getValueForKey(Constants.userTokenKey) else {
      return
    }

    HUD.show()
    AuthClient.signOut(token) { success in
      HUD.hide()

      if success {
        KeyChainService.shared.deleteKey(Constants.userTokenKey)
        self.webView.loadRequest(NSURLRequest(URL: blankURL))
        self.presentSignIn()
      } else {
        self.presentErrorAlert("Error signing out.")
      }
    }
  }

  private func presentSignInOrLoadURL(url: NSURL) {
    if let request = authorizedRequestForURL(url) {
      // If signed in, set sign out button
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .Plain, target: self, action: Selector("didTapSignOut"))

      webView.loadRequest(request)
    } else {
      presentSignIn()
    }
  }

  private func presentSignIn() {
    let signInViewController = SignInViewController()
    signInViewController.delegate = self

    let navController = UINavigationController(rootViewController: signInViewController)
    navController.navigationBar.translucent = false

    presentViewController(navController, animated: true, completion: nil)
  }

  private func authorizedRequestForURL(url: NSURL) -> NSURLRequest? {
    if let token = KeyChainService.shared.getValueForKey(Constants.userTokenKey) {
      let request = NSMutableURLRequest(URL: url)
      request.setValue(token, forHTTPHeaderField: Constants.httpUserTokenHeader)
      return request
    } else {
      return nil
    }
  }

  private func authorizedRequestForRequest(request: NSURLRequest) -> NSURLRequest? {
    if let token = KeyChainService.shared.getValueForKey(Constants.userTokenKey) {
      let authorizedRequest = request.mutableCopy()
      authorizedRequest.setValue(token, forHTTPHeaderField: Constants.httpUserTokenHeader)

      return authorizedRequest as? NSURLRequest
    } else {
      return nil
    }
  }

  private func signedIn() -> Bool {
    return KeyChainService.shared.getValueForKey(Constants.userTokenKey) != nil
  }

  private func presentErrorAlert(message: String) {
    let alertController = UIAlertController(title: "Web error", message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

    alertController.addAction(action)

    presentViewController(alertController, animated: true, completion: nil)
  }
}

extension WebViewController: UIWebViewDelegate {
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    guard signedIn() else {
      return true
    }

    if request.valueForHTTPHeaderField(Constants.httpUserTokenHeader) != nil {
      return true
    } else {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        dispatch_async(dispatch_get_main_queue()) {
          if let authorizedRequest = self.authorizedRequestForRequest(request) {
            webView.loadRequest(authorizedRequest)
          } else {
            print("Unable to generate authorized request")
          }
        }
      }

      return false
    }
  }

  func webViewDidStartLoad(webView: UIWebView) {
    HUD.show()
  }


  func webViewDidFinishLoad(webView: UIWebView) {
    HUD.hide()
  }

  func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    if let error = error {
      presentErrorAlert(error.localizedDescription)
    }
  }
}

extension WebViewController: SignInViewControllerDelegate {
  func signInViewController(viewController: SignInViewController, didSucceedWithToken token: String) {
    KeyChainService.shared.setValue(token, forKey: Constants.userTokenKey)

    presentSignInOrLoadURL(rootURL)

    dismissViewControllerAnimated(true, completion: nil)
  }
}
