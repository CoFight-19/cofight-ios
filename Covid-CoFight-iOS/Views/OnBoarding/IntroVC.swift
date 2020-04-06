//
//  IntroVC.swift
//  CovidGuard
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift

class IntroVC : UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var showMeButton: UIButton! {
        didSet {
            showMeButton.layer.cornerRadius = showMeButton.frame.height/2
        }
    }
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    //MARK: - Properties
    static let identifier = "IntroVC"

    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        self.setupUI()
        self.navigationController?.navigationBar.isHidden = true
    }

    //MARK: - UI Functions
    private func setupUI() {
        self.subtitleLabel.text = "Stop the spread of COVID-19 in Cyprus".localized()
        showMeButton.setTitle("Show me how".localized(), for: .normal)
        if Localize.currentLanguage().contains("el") {
            self.languageButton.setTitle("ΕΛ", for: .normal)
        }
        else {
            self.languageButton.setTitle("EN", for: .normal)
        }
    }
    
    @IBAction func changeLanguageIBAction(_ sender: Any) {
        let alert = UIAlertController(title: "Select language".localized(), message:nil, preferredStyle: .actionSheet)
          
         alert.addAction(UIAlertAction(title: "Ελληνικά", style: .default, handler: {(_) in
              DispatchQueue.main.async {
                Localize.setCurrentLanguage("el")
                self.setupUI()
              }
         }))
       
        alert.addAction(UIAlertAction(title: "English", style: .default, handler: {(_) in
            DispatchQueue.main.async {
                Localize.setCurrentLanguage("en")
                self.setupUI()
            }
        }))
         alert.addAction(UIAlertAction(title:"Cancel".localized(), style: .cancel, handler:nil))
         self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showMeIBAction(_ sender: Any) {
        if let vc = IntroMessageVC.viewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Class Functions
    class func viewController() -> IntroVC? {
        let controller = UIStoryboard(name: StoryboardKeys.onBoarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: IntroVC.identifier) as? IntroVC
        return controller
    }
}
