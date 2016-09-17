//
//  Validation.swift
//  student-id
//
//  Created by John Clarke on 9/17/16.
//  Copyright © 2016 John Clarke. All rights reserved.
//

import Foundation

class Validation {
    
    // Range Check
    static func isInRange(_ text: String, lo: Int, hi: Int) -> Bool {
        let textLength = text.characters.count
        if (textLength >= lo && textLength <= hi) {
            return true
        } else {
            return false
        }
    }
    
    // Alpha Numeric Character Check
    static func isAlphaNumeric(_ text: String) -> Bool {
        let alphaNumerics = CharacterSet.alphanumerics
        for char in text.utf16 {
            if !alphaNumerics.contains(UnicodeScalar(char)!) {
                return false
            }
        }
        return true
    }
    
    // determines if email is valid by regular expressions
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
