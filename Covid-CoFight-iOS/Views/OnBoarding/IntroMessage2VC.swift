//
//  IntroMessage2VC.swift
//  CovidGuard
//
//  Created by "" on 25/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import UIKit

class IntroMessage2VC : UIViewController {
    //MARK: - IBOutlets

    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setTitle("Next".localized(), for: .normal)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
        }
    }
    
    @IBOutlet weak var title1Label: UILabel! {
        didSet {
            title1Label.text = "Location Privacy".localized()
        }
    }
    @IBOutlet weak var body1Label: UILabel! {
           didSet {
               body1Label.text = "The app does NOT track your location or your contacts.\n\nData is stored locally on your phone and can’t be accessed unless you had a close contact with a confirmed case.".localized()
           }
    }
    
    @IBOutlet weak var title2Label: UILabel! {
        didSet {
            title2Label.text = "Phone Number Privacy".localized()
        }
    }
    @IBOutlet weak var body2Label: UILabel! {
           didSet {
               body2Label.text = "Your phone number stays private. Your number is paired with a random ID. That ID is exchanged between phones, not your actual number.".localized()
           }
    }
    
    @IBOutlet weak var title3Label: UILabel! {
        didSet {
            title3Label.text = "Battery Consumption".localized()
        }
    }
    @IBOutlet weak var body3Label: UILabel! {
           didSet {
               body3Label.text = "The app was designed to keep battery consumption to a minimum. Make sure you have the app running, especially when leaving your house for best results.".localized()
           }
    }
    
    @IBOutlet weak var title4Label: UILabel! {
        didSet {
            title4Label.text = "Close Contact".localized()
        }
    }
    @IBOutlet weak var body4Label: UILabel! {
           didSet {
               body4Label.text = "If you came in close contact with a CovidGuard user of a confirmed case, you will be contacted directly by SMS or by phone. Your permission might be required to access your stored app data.".localized()
           }
    }
    
    //MARK: - Properties
    static let identifier = "IntroMessage2VC"

    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func nextIBAction(_ sender: Any) {
        if let vc = SignupVC.viewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK: - Class Functions
    class func viewController() -> IntroMessage2VC? {
        let controller = UIStoryboard(name: StoryboardKeys.onBoarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: IntroMessage2VC.identifier) as? IntroMessage2VC
        return controller
    }
}
