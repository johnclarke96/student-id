//
//  MainViewController.swift
//  student-id
//
//  Created by John Clarke on 9/17/16.
//  Copyright © 2016 John Clarke. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {

    var email: String = ""

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentPhoto: UIImageView!
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var studentBarcode: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // if first login, call API to gather student information
        
        let name: String = Cache.sharedInstance.firstName + " " + Cache.sharedInstance.lastName
        //let photo: UIImage = UIImage(contentsOfFile: Cache.sharedInstance.imagePath)!
        //let photo: UIImage = UIImage(contentsOfFile: "/Users/jaclarke/Desktop/student-id/photos/jaclarke.jpg")!
        
        let sName: String = Cache.sharedInstance.schoolName
        
        let barcodeString: String = Cache.sharedInstance.barcode
        let barcode: Barcode = Barcode(barcode: barcodeString)
        let barcodePhoto = barcode.getBarcode()
        
        Alamofire.request(Cache.sharedInstance.imagePath).responseData { response in
            if let data = response.result.value {
                let image = UIImage(data: data, scale: 1)!
                self.studentPhoto.image = image
            } else {
                print("Error retrieving image!")
            }
        }

        studentName.text = name
        //studentPhoto.image = photo
        schoolName.text = sName
        studentBarcode.image = barcodePhoto
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

