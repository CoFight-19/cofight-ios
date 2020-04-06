//
//  APIRequest.swift
//  CovidGuard
//
//  Created by "" on 25/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import Alamofire

protocol APIRequest {
    static var headers : HTTPHeaders? {get}
    var parameters : [Codable]? {get}
    static var path : String {get}
    static var method : HTTPMethod {get}
}

extension APIRequest {
    static var headers : HTTPHeaders? {
        return nil
    }
    
    var parameters : [Codable]? {
        return nil
    }
    
    static var path: String {
        return ConfigurationController.baseURL

    }
    
    static var method : HTTPMethod {
        return .post
    }
    
    var response : DataResponse<Data?, AFError>? {
        return nil
    }
}
