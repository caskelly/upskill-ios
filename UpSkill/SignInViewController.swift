//
//  Copyright 2013-2016 Microsoft Inc.
//

import UIKit

protocol SignInViewControllerDelegate: class {
  func signInViewController(viewController: SignInViewController, didSucceedWithToken token: String)
}

class SignInViewController: UIViewController {
  weak var delegate: SignInViewControllerDelegate?

  private let emailField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Email"
    textField.textColor = .blackColor()
    textField.textAlignment = .Center
    textField.autocapitalizationType = .None
    textField.autocorrectionType = .No

    return textField;
  }()
  private let passwordField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Password"
    textField.secureTextEntry = true
    textField.textColor = .blackColor()
    textField.textAlignment = .Center

    return textField;
  }()

  private let signInButton: UIButton = {
    let button = UIButton(type: .RoundedRect)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Sign In", forState: .Normal)
    button.setTitleColor(.blueColor(), forState: .Normal)

    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Sign In"
    view.backgroundColor = .whiteColor()

    signInButton.addTarget(self, action: Selector("didTapSignIn"), forControlEvents: .TouchUpInside)

    view.addSubview(emailField)
    view.addSubview(passwordField)
    view.addSubview(signInButton)

    let constraintViews = [
      "emailField": emailField,
      "passwordField": passwordField,
      "signInButton": signInButton
    ]

    var viewConstraints = [NSLayoutConstraint]()
    viewConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|[emailField]|", options: [], metrics: nil, views: constraintViews)
    viewConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|[passwordField]|", options: [], metrics: nil, views: constraintViews)
    viewConstraints.append(NSLayoutConstraint(item: signInButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    viewConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[emailField]-[passwordField]-30-[signInButton]", options: [], metrics: nil, views: constraintViews)

    NSLayoutConstraint.activateConstraints(viewConstraints)
  }

  @objc private func didTapSignIn() {
    guard let email = emailField.text, password = passwordField.text where !(email.isEmpty || password.isEmpty) else {
      return
    }

    HUD.showWithTitle("Signing In...")
    AuthClient.signIn(email, password: password) { retrieveToken in
      HUD.hide()

      do {
        if let token = try retrieveToken() {
          self.delegate?.signInViewController(self, didSucceedWithToken: token)
        } else {
          print("No token found")
        }
      } catch AuthClientError.NonSuccess {
        print("Non-200 response")
      } catch let error as NSError {
        print("Error: \(error.localizedDescription)")
      }
    }
  }
}
