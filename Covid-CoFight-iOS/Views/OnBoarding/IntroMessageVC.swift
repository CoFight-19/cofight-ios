//
//  IntroMessageVC.swift
//  CovidGuard
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift

class IntroMessageVC : UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setTitle("Next".localized(), for: .normal)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
        }
    }
    @IBOutlet weak var title1Label: UILabel! {
        didSet {
            title1Label.text = "Why Use CovidGuard?".localized()
        }
    }
    @IBOutlet weak var body1Label: UILabel! {
           didSet {
               body1Label.text = "By using the app you can contribute to a faster detection of COVID-19 cases.\n\nIf you come in close contact with a confirmed case, we can contact you and others much faster, thus stopping the spread of the virus.".localized()
           }
    }
    
    @IBOutlet weak var title2Label: UILabel! {
        didSet {
            title2Label.text = "How It Works".localized()
        }
    }
    @IBOutlet weak var body2Label: UILabel! {
           didSet {
               body2Label.text = "Using only Bluetooth, CovidGuard identifies nearby phones that have the app installed.\n\nIt records the IDs of phones you come in close proximity (less than 4 meters), and a timestamp.\n\nIf necessary, this information can be used to identify if you had any close contacts and their duration.".localized()
           }
    }
    
    //MARK: - Properties
    static let identifier = "IntroMessageVC"

    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func nextIBAction(_ sender: Any) {
        if let vc = IntroMessage2VC.viewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK: - Class Functions
    class func viewController() -> IntroMessageVC? {
        let controller = UIStoryboard(name: StoryboardKeys.onBoarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: IntroMessageVC.identifier) as? IntroMessageVC
        return controller
    }
}
