//
//  Image.swift
//  student-id
//
//  Created by John Clarke on 9/17/16.
//  Copyright © 2016 John Clarke. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Image {
    
    private let imageURL: String
    private let identifier: String
    
    // identifier is schoolName + schoolID
    init(imageURL: String, identifier: String) {
        self.imageURL = imageURL
        self.identifier = identifier
    }
    
    func getImageAndSaveToDisk(_ callback: @escaping (String) -> Void) {
        Alamofire.request(self.imageURL).responseData { response in
            if let data = response.result.value {
                let image = UIImage(data: data, scale: 1)!
                if let data = UIImageJPEGRepresentation(image, 0.8) {
                    let filename = Image.getDocumentsDirectory().appendingPathComponent(self.identifier)
                    do {
                        try data.write(to: filename)
                    } catch {
                        print("file didn't write")
                    }
                    print("about to call the callback")
                    callback(filename.path)
                }
            } else {
                print("Error retrieving image!")
            }
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
