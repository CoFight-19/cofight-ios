//
//  VerifyVC.swift
//  CovidGuard
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Localize_Swift
class VerifyVC : UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var verifyView : UIView! {
       didSet {
           verifyView.layer.cornerRadius = verifyView.frame.height/2
           verifyView.layer.borderColor = UIColor.projectPurple.cgColor
           verifyView.layer.borderWidth = 4
        }
    }
    @IBOutlet weak var verifyCodeTextField : UITextField! {
        didSet {
            verifyCodeTextField.defaultTextAttributes.updateValue(3.0, forKey: NSAttributedString.Key.kern)
            verifyCodeTextField.delegate = self
        }
    }
    @IBOutlet weak var verifyLabel : UILabel! {
        didSet {
            self.verifyLabel.text = "\("Enter the code sent to".localized()) \(ConfigurationController.telephoneCountryCode) \(self.telephone!)"
        }
    }
    @IBOutlet weak var wrongNumberButton: UIButton! {
        didSet {
            wrongNumberButton.setTitle("Wrong number?".localized(), for: .normal)
        }
    }
    @IBOutlet weak var sendNewCodeButton: UIButton! {
          didSet {
              sendNewCodeButton.setTitle("Send a new code now".localized(), for: .normal)
          }
      }
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.text = "Invalid code. Please try again".localized()
        }
    }
    @IBOutlet weak var sendNewCodeButtonBottom: NSLayoutConstraint!

    
    //MARK: - Properties
    static let identifier = "VerifyVC"
    var telephone : String!
    var keyboardHeight = CGFloat(0) {
        didSet {
            sendNewCodeButtonBottom.constant = keyboardHeight + CGFloat(20)
        }
    }

    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        self.addObservers()
        self.errorLabel.isHidden = true
    }
    deinit {
        self.removeObservers()
    }
    
    //MARK: - UI Functions
    private func setupUI() {
        //self.countryCodeLabel.text = ConfigurationController.countryCode
    }
    
    func addObservers () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.verifyCodeTextField.becomeFirstResponder()
    }
    func removeObservers () {
           NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.keyboardHeight = 0
    }

    private func goToMainView() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.goToAppropriateVC()
        }
    }
    //MARK: - IBActions
    @IBAction func resendIBAction(_ sender: Any) {
        self.resendCode()
    }
    @IBAction func wrongNumberIBAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Data Functions
    private func validateCode(code:String) {
        SVProgressHUD.show()
        AuthenticationRepository.activate(telephone: self.telephone, auth_code: code, completion: { (user) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if let _ = user {
                    self.goToMainView()
                }
                else {
                    self.errorLabel.isHidden = false
                }
            }
            
        })
    }
    private func resendCode () {
        SVProgressHUD.show()
        AuthenticationRepository.register(telephone:telephone,completion: { code in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if let code = code, code == "1" {
                    
                }
                else {
                    self.popUpOptionDialog(content: "Something went wrong. Please try again!")
                }
            }
        })
    }
    //MARK: - Class Functions
    class func viewController(telephone:String) -> VerifyVC? {
        let controller = UIStoryboard(name: StoryboardKeys.onBoarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: VerifyVC.identifier) as? VerifyVC
        controller?.telephone = telephone
        return controller
    }
}

extension VerifyVC : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.count == 4, let _ = Int(text) {
            self.validateCode(code: text)
        }
        else {
            self.errorLabel.isHidden = true
        }
    }
}
