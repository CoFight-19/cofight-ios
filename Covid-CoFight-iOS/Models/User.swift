//
//  User.swift
//  CovidGuard
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//
import Foundation

struct User : Codable {
    var user_id : Int
    var access_token : String
    
    static func getLoggedInUser () -> User? {
        return KeychainController.getCurrentUser()
    }
    
    static func saveUser(user:User) {
        return KeychainController.saveCurrentUser(user: user)
    }
    
    static func logout() {
        KeychainController.deleteAll()
    }
}
