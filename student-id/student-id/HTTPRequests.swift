//
//  HTTPRequests.swift
//  student-id
//
//  Created by John Clarke on 9/17/16.
//  Copyright © 2016 John Clarke. All rights reserved.
//

import Foundation
import Alamofire

class HTTPRequests {
    
    let host: String
    let port: String
    let resource: String
    let params: [String:String]
    
    init(host: String, port: String, resource: String, params: [String:String] = [:]) {
        self.host = host
        self.port = port
        self.resource = resource
        self.params = params
    }
    
    func POST(_ callback: @escaping (_ json: [String:AnyObject]) -> Void) {
        let url: String = "http://" + host + ":" + port + "/" + resource
        Alamofire.request(url, method: .post, parameters: self.params).responseJSON { response in
            switch response.result {
            case .success(let data):
                let data = data as! [String:AnyObject]
                callback(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func GET(_ callback: @escaping (_ json: [String:AnyObject]) -> Void) {
        let url: String = "http://" + host + ":" + port + "/" + resource
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let data):
                let data = data as! [String:AnyObject]
                callback(data)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func PUT(_ callback: @escaping (_ json: [String:AnyObject]) -> Void) {
        let url: String = "http://" + host + ":" + port + "/" + resource
        Alamofire.request(url, method: .put, parameters: self.params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                let data = data as! [String:AnyObject]
                callback(data)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}

