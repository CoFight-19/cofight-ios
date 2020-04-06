//
//  SignupVC.swift
//  CovidGuard
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift

import  SVProgressHUD
class SignupVC : UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var telephoneView : UIView! {
        didSet {
            telephoneView.layer.cornerRadius = telephoneTextField.frame.height/2
            telephoneView.layer.borderColor = UIColor.projectPurple.cgColor
            telephoneView.layer.borderWidth = 4
        }
    }
    @IBOutlet weak var smsLabel: UILabel! {
        didSet {
            smsLabel.text = "You will receive an SMS with a verification code".localized()
        }
    }
    @IBOutlet weak var telephoneTextField : UITextField! {
        didSet {
            telephoneTextField.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
            telephoneTextField.delegate = self
        }
    }
    
    @IBOutlet weak var enterPhoneLabel: UILabel! {
        didSet {
            enterPhoneLabel.text = "Enter your phone number to get started".localized()
        }
    }
    @IBOutlet weak var doneView : UIView!
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.setTitle("Done".localized(), for: .normal)
            doneButton.layer.cornerRadius = doneButton.frame.height/2
        }
    }
    @IBOutlet weak var doneViewBottom: NSLayoutConstraint!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    //MARK: - Properties
    static let identifier = "SignupVC"
    
    var keyboardHeight = CGFloat(0)
    
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        self.addObservers()
        self.setupUI()
    }
    
    deinit {
        self.removeObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.telephoneTextField.becomeFirstResponder()
    }
    //MARK: - UI Functions
    private func setupUI() {
        self.countryCodeLabel.text = ConfigurationController.telephoneCountryCode
    }
    func addObservers () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

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
    
    func showDone(show:Bool) {
        if show {
            self.doneView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.doneViewBottom.constant = self.keyboardHeight
                self.view.setNeedsLayout()
            })
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                self.doneViewBottom.constant = 0
                self.view.setNeedsLayout()
            }, completion:{ (finished: Bool) in 
                self.doneView.isHidden = true
            })
        }
    }
    
    func goToVerifyVC() {
        if let telephone = self.telephoneTextField.text, let verifyVC = VerifyVC.viewController(telephone: telephone) {
            self.navigationController?.pushViewController(verifyVC, animated: true)
        }
    }
    
    //MARK: - IBActions
    @IBAction func registerIBAction(_ sender: Any) {
        SVProgressHUD.show()
        if let textfield = telephoneTextField.text {
            AuthenticationRepository.register(telephone:textfield,completion: { code in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if let code = code, code == "1" {
                    self.goToVerifyVC()
                }
                else {
                    self.popUpOptionDialog(content: "Something went wrong. Please try again!")
                }
            }
        })
        
        }
    }
    
    //MARK: - Class Functions
    class func viewController() -> SignupVC? {
        let controller = UIStoryboard(name: StoryboardKeys.onBoarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: SignupVC.identifier) as? SignupVC
        return controller
    }
}

extension SignupVC : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.count == ConfigurationController.telephoneLength,text.first == ConfigurationController.telephonePrefix.first, let _ = Int(text) {
            self.showDone(show: true)
        }
        else if !self.doneView.isHidden {
            self.showDone(show: false)
        }
    }
}
