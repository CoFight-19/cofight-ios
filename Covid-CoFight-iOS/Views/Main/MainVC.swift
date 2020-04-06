//
//  MainViewController.swift
//  CovidGuard
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import UIKit
import CoreBluetooth
import SVProgressHUD
import Localize_Swift
class MainVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var darkModeView: UIView! {
        didSet {
            darkModeView.isHidden = true
            darkModeView.isUserInteractionEnabled = true
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.disableDarkView))
            recognizer.numberOfTapsRequired = 2
            darkModeView.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var batteryLabel: UILabel! {
        didSet {
            batteryLabel.text = "Battery Saver Mode is enabled.\nTo exit: double-tap anywhere on the screen".localized()
        }
    }
    @IBOutlet weak var shareLabel: UILabel! {
        didSet {
            shareLabel.text = "Share the app to keep your\nfamily & friends safe".localized()
        }
    }
    @IBOutlet weak var debugButton: UIButton!
    @IBOutlet weak var bluetoothImageView: UIImageView!
    @IBOutlet weak var scanningLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var uploadButtonLabel: UILabel! {
        didSet {
            uploadButtonLabel.text = "Upload".localized()
        }
    }
    @IBOutlet weak var settingsButtonLabel: UILabel! {
        didSet {
            settingsButtonLabel.text = "Settings".localized()
        }
    }
    @IBOutlet weak var batterySaveButton: UIButton! {
        didSet {
            batterySaveButton.setTitle("Enable Battery Saver".localized(), for: .normal)
            batterySaveButton.layer.cornerRadius = batterySaveButton.frame.height/2
        }
    }
    
    //MARK: - Delegate Properties
    
    //MARK: - Properties
    static let identifier = "MainVC"
    
    var manager = BluetoothManager()
       
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        //Keeping the device from auto-locking
        UIApplication.shared.isIdleTimerDisabled = true
 
        manager.delegate = self
        manager.start()
    }
    //MARK: - UI Functions
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        #if DEBUG
        self.debugButton.isHidden = false
        #else
        self.debugButton.isHidden = true
        #endif
        self.debugButton.isHidden = false

    }
    
    private func enableBatterySaveButton(enable:Bool) {
        self.batterySaveButton.isUserInteractionEnabled = enable
        self.batterySaveButton.alpha = enable ? 1 : 0.5
    }

    
    private func enableBluetoothUI(enable:Bool) {
        self.enableBatterySaveButton(enable: enable)
        self.bluetoothImageView.image = enable ? #imageLiteral(resourceName: "bluetooth") : #imageLiteral(resourceName: "no-bluetooth")
        
        self.scanningLabel.textColor = enable ? UIColor.projectGreen : UIColor.projectRed
        self.scanningLabel.text = enable ? "Enabled".localized() : "Disabled".localized()
        
        if enable {
            self.messageLabel.attributedText = NSAttributedString(string: "Important: The app must be left open to continue scanning (iPhone limitation)".localized(), attributes: [NSAttributedString.Key.font:ProjectFonts.defaultFont(13, weight: .semibold),NSAttributedString.Key.foregroundColor:UIColor.projectLightGray])
        }
        else {
            let attrString = NSMutableAttributedString(string:"Bluetooth is disabled. \nPlease enable it from the ".localized(),attributes: [NSAttributedString.Key.font:ProjectFonts.defaultFont(13, weight: .semibold),NSAttributedString.Key.foregroundColor:UIColor.projectLightGray])
            attrString.append(NSAttributedString(string:"iPhone Settings".localized(),attributes: [NSAttributedString.Key.font:ProjectFonts.defaultFont(13, weight: .semibold),NSAttributedString.Key.foregroundColor:UIColor.projectLightGray]))
            self.messageLabel.attributedText = attrString
        }
    }
    @objc private func disableDarkView() {
        self.enableBaterySaveMode(enable: false)
    }
    private func enableBaterySaveMode(enable:Bool) {
        self.darkModeView.isHidden = !enable
        UIScreen.main.brightness = CGFloat(enable ? 0.01 : 0.5)
    }
    
    private func showTermsAndConditions() {
        self.openInAppWebsite(urlString: ConfigurationController.termsAndconditionsURL)
    }
   
    private func showCredits() {
        self.openInAppWebsite(urlString: ConfigurationController.creditsURL)
    }
   
    //MARK: - Popups
    private func shareApp() {
        let activityViewController = UIActivityViewController(activityItems: ["Your share message"], applicationActivities: nil)
        activityViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(activityViewController, animated: true, completion: nil)
    }
    private func enableBatterySaverPopup() {
        let alert = UIAlertController(title: "Battery Saver Will Be Enabled".localized(), message:"The screen will become dark with low brightness to preserve battery. It will also LOCK to prevent accidental taps. To exit Battery Saver Mode, double-tap anywhere on the screen".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Not now".localized(), style: .default, handler: {(_) in
             DispatchQueue.main.async {
                
             }
        }))
        
        alert.addAction(UIAlertAction(title: "Enable now".localized(), style: .default, handler: {(_) in
             DispatchQueue.main.async {
                self.enableBaterySaveMode(enable: true)
             }
        }))
        self.present(alert, animated: true, completion: nil)
    
    }
    private func uploadDataPopup() {
        let alert = UIAlertController(title: "Upload your data only after getting notified via SMS/call of a COVID-19 close contact. Are you sure?".localized(), message:nil, preferredStyle: .actionSheet)
         
        alert.addAction(UIAlertAction(title: "Yes, upload my data".localized(), style: .default, handler: {(_) in
             DispatchQueue.main.async {
                self.uploadData()
             }
        }))
       
        alert.addAction(UIAlertAction(title:"Cancel".localized(), style: .cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func showSettings() {
        let alert = UIAlertController(title: "Settings".localized(), message:nil, preferredStyle: .actionSheet)
         
        alert.addAction(UIAlertAction(title: "Share CovidGuard", style: .default, handler: {(_) in
             DispatchQueue.main.async {
                self.shareApp()
             }
        }))
       
        alert.addAction(UIAlertAction(title: "Upload My Data".localized(), style: .default, handler: {(_) in
            DispatchQueue.main.async {
                self.uploadDataPopup()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Terms & Conditions".localized(), style: .default, handler: {(_) in
            DispatchQueue.main.async {
                self.showTermsAndConditions()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Credits".localized(), style: .default, handler: {(_) in
                DispatchQueue.main.async {
                    self.showCredits()
                }
        }))
        
        let logout = UIAlertAction(title: "Logout & Delete All Data".localized(), style: .default, handler: {(_) in
            DispatchQueue.main.async {
                KeychainController.deleteAll()
                 if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.goToAppropriateVC()
                }
            }
        })
        
        logout.titleTextColor = UIColor.projectRed
        alert.addAction(logout)

        alert.addAction(UIAlertAction(title:"Cancel".localized(), style: .cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Functions
    private func uploadData() {
       if let devices = Device.getSavedDevices(), let jsonData = Device.toDeviceJSON(devices: devices) {
           SVProgressHUD.show()
           MainRepository.userUploadData(jdata:jsonData, completion: {response in
               DispatchQueue.main.async {
                   SVProgressHUD.dismiss()
                   if let response = response, response == "true" {
                       self.popUpOptionDialog(content: "Successfull submission!".localized())
                   }
                   else {
                       self.popUpOptionDialog(content: "Something went wrong. Please try again!".localized())
                   }
               }
           })
       }
    }
    
    
    //MARK: - IBActions
    @IBAction func uploadIBAction(_ sender: Any) {
        self.uploadDataPopup()
    }
    
    @IBAction func settings(_ sender: Any) {
        self.showSettings()
    }
    
    @IBAction func shareIBAction(_ sender: Any) {
        self.shareApp()
    }
    
    @IBAction func enableBatterySaveIBAction(_ sender: Any) {
        self.enableBatterySaverPopup()
    }
    
    @IBAction func debugIBAction(_ sender: Any) {
        if let devices = Device.getSavedDevices(), let debugVC = DebugVC.viewController(devices: devices) {
            self.navigationController?.pushViewController(debugVC, animated: true)
        }
    }
    //MARK: - Class Functions
    class func viewController() -> MainVC? {
        let controller = UIStoryboard(name: StoryboardKeys.main.rawValue, bundle: nil).instantiateViewController(withIdentifier: MainVC.identifier) as? MainVC
        return controller
    }
}

extension MainVC : BluetoothManagerDelegate {
    func bluetoothState(state: CBManagerState) {
        self.enableBluetoothUI(enable:state == .poweredOn)
    }
}
