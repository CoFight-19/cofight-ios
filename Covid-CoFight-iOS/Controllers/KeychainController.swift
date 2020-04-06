//
//  KeychainController.swift
//  Covid-CoFight-iOS
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import KeychainAccess

enum KeychainKeys : String {
    case currentProject = "CovidGuard"
    case devices = "devices"
    case currentUser = "current_user"
}

class KeychainController {
    
    class func saveCurrentUser(user:User) {
        do {
            let userJSON = try JSONEncoder().encode(user)
            if let data = String(data: userJSON, encoding: .utf8) {
                KeychainController.save(data, for: KeychainKeys.currentUser.rawValue)
            }
        }
        catch {
            print(error)
        }
    }
    
    class func getCurrentUser() -> User? {
           do {
            if let userJSON = KeychainController.retrieveData(for: KeychainKeys.currentUser.rawValue) {
                    let user = try JSONDecoder().decode(User.self, from: Data(userJSON.utf8))
                    return user
                }
               return nil
           }
           catch {
                print(error)
                return nil
           }
    }
    
    class func save(_ data: String, for key: String) {
        let keychain = Keychain(service: KeychainKeys.currentProject.rawValue)
        keychain[key] = data
    }

    
    class func delete(for key: String) {
       let keychain = Keychain(service: KeychainKeys.currentProject.rawValue)
       try? keychain.remove(key)
    }
    
    class func retrieveData(for key: String) -> String? {
        let keychain = Keychain(service: KeychainKeys.currentProject.rawValue)
        return keychain[key]
    }
    
    class func deleteAll() {
        let keychain = Keychain(service: KeychainKeys.currentProject.rawValue)
        try? keychain.removeAll()
    }
    
}

extension OSStatus {

    var error: NSError? {
        guard self != errSecSuccess else { return nil }
        var message = ""
        if #available(iOS 11.3, *) {
            message = SecCopyErrorMessageString(self, nil) as String? ?? "Unknown error"
        } else {
            message = ""// Fallback on earlier versions
        }

        return NSError(domain: NSOSStatusErrorDomain, code: Int(self), userInfo: [
            NSLocalizedDescriptionKey: message])
    }
}
