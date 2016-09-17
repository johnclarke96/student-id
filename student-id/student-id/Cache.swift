//
//  Cache.swift
//  student-id
//
//  Created by John Clarke on 9/17/16.
//  Copyright © 2016 John Clarke. All rights reserved.
//

import Foundation

class Cache {
    var firstName: String
    var lastName: String
    var studentID: String
    var schoolName: String
    var imagePath: String
    var barcode: String
    
    private init(firstName: String = "", lastName: String = "", studentID: String = "", schoolName: String = "", imagePath: String = "", barcode: String = ""){
        self.firstName = firstName
        self.lastName = lastName
        self.studentID = studentID
        self.schoolName = schoolName
        self.imagePath = imagePath
        self.barcode = barcode
    }
    
    static func initCache(firstName: String, lastName: String, studentID: String, schoolName: String, imagePath: String, barcode: String) -> Void {
        let instance = Cache.sharedInstance
        instance.firstName = firstName
        instance.lastName = lastName
        instance.studentID = studentID
        instance.schoolName = schoolName
        instance.imagePath = imagePath
        instance.barcode = barcode
    }

    static let sharedInstance = Cache()
}
