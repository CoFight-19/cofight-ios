//
//  MainRepository.swift
//  CovidGuard
//
//  Created by "" on 25/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import Alamofire
import Foundation

enum MainMethods : String {
    case userUploadData = "user_upload_data"
}

struct MainProperties : Codable {
    var method : String
    var user_id: String?
    var access_token : String?
    var jdata : String?
}

struct MainRepository : APIRequest {
    
    static func userUploadData(jdata:String, completion:@escaping(String?) ->Void) {
        guard let user = User.getLoggedInUser() else {
            completion(nil)
            return
        }
    
        let authenticationProperties = MainProperties(method:MainMethods.userUploadData.rawValue,user_id:String(user.user_id),access_token: user.access_token,jdata: jdata)
            
        AF.request(path,method:method,parameters: authenticationProperties, encoder: URLEncodedFormParameterEncoder.default, headers:nil).validate().response { response in
            if let jsonData = response.data, let response =  String(data: jsonData, encoding: String.Encoding.utf8) {
                //Something went wrong
                if response == "true" {
                    completion("true")
                }
                else {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        }
    }
}
