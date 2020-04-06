//
//  AuthenticationRepository.swift
//  CovidGuard
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Alamofire
import Foundation
enum AuthenticationMethods : String {
    case userRegister = "user_register"
    case userActivate = "user_activate"

}

struct AuthenticationProperties : Codable {
    var method : String
    var telephone: String?
    var auth_code : String?
    
}

struct AuthenticationRepository : APIRequest {
    
    static func register(telephone:String, completion:@escaping(String?) ->Void) {
        let authenticationProperties = AuthenticationProperties(method:AuthenticationMethods.userRegister.rawValue,telephone:telephone)
               AF.request(path,method:method, parameters: authenticationProperties, encoder: URLEncodedFormParameterEncoder.default, headers:nil).validate().response { response in
                   if let jsonData = response.data, let code =  String(data: jsonData, encoding: String.Encoding.utf8) {
                    //Something went wrong
                    if code == "0" {
                        completion(nil)
                    }
                    else {
                        completion(code)
                    }
                   }
                   else {
                    completion(nil)
                }
               }
    }
    
    static func activate(telephone:String,auth_code:String,completion:@escaping(User?) ->Void) {
        let authenticationProperties = AuthenticationProperties(method:AuthenticationMethods.userActivate.rawValue,telephone:telephone,auth_code:auth_code)
                AF.request(path,method:method,parameters: authenticationProperties, encoder: URLEncodedFormParameterEncoder.default, headers:nil).validate().response { response in
                    if let jsonData = response.data {
                        do {
                            let user = try JSONDecoder().decode(User.self,from: jsonData)
                            if user.user_id != 0 {
                                User.saveUser(user: user)
                                completion(user)
                            }
                            else {
                                completion(nil)
                            }
                        }
                        catch{
                            completion(nil)
                        }
                    }
        }
    }
}
