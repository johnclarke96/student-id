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

        let photo: UIImage = UIImage(contentsOfFile: Cache.sharedInstance.imagePath)!
        
        let sName: String = Cache.sharedInstance.schoolName
        
        let barcodeString: String = Cache.sharedInstance.studentID
        let barcode: Barcode = Barcode(barcode: barcodeString)
        let barcodePhoto = barcode.getBarcode()

        studentName.text = name
        studentPhoto.image = photo
        schoolName.text = sName
        studentBarcode.image = barcodePhoto
    }
    
    
    @IBAction func changePassword(_ sender: AnyObject) {
        let message: String = "An email to change your password will be sent to " + self.email + "."
        let alert = UIAlertController(title: "Request Password Change", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: {
            let params = ["email": self.email]
            let http = HTTPRequests(host: "18.111.86.205", port: "5000", resource: "password_reset", params: params)
            http.POST({ (json) -> Void in
                let message1 = json["message"] as! String
                let alert1 = UIAlertController(title: "Request Processed", message: message1, preferredStyle: .alert)
                let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert1.addAction(action1)
                self.present(alert1, animated: true, completion: nil)
            })
        })
    }

    @IBAction func quit(_ sender: AnyObject) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

