//
//  DebugVC.swift
//  CovidGuard
//
//  Created by "" on 25/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import UIKit

class DebugVC : UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: DefaultCell.nibName, bundle: nil), forCellReuseIdentifier: DefaultCell.identifier)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //MARK: - Delegate Properties
    
    //MARK: - Properties
    static let identifier = "DebugVC"
    
    var devices = [Device]()
    
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        self.tableView.reloadData()
    }
    @IBAction func deleteAllIBAction(_ sender: Any) {
        self.devices = [Device]()
        Device.deleteAllDevices()
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Class Functions
    class func viewController(devices:[Device]) -> DebugVC? {
        let controller = UIStoryboard(name: StoryboardKeys.main.rawValue, bundle: nil).instantiateViewController(withIdentifier: DebugVC.identifier) as? DebugVC
        controller?.devices = devices
        return controller
    }
}

extension DebugVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath) as? DefaultCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "id \(devices[indexPath.row].user_id) -  ts \(devices[indexPath.row].ts)"
        return cell
    }
}

extension DebugVC : UITableViewDelegate {

}
