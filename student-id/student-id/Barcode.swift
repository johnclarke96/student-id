//
//  Barcode.swift
//  student-id
//
//  Created by John Clarke on 9/17/16.
//  Copyright © 2016 John Clarke. All rights reserved.
//

import Foundation
import UIKit

class Barcode {
    
    private var barcodeString: String
    
    init(barcode:String) {
        self.barcodeString = barcode
    }
    
    // input: none (instance variable barcodeString)
    // output: UIImage representation of barcodeString
    public func getBarcode() -> UIImage? {
        let data = self.barcodeString.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
