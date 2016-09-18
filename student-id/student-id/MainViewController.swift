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
        self.navigationItem.setHidesBackButton(true, animated: false)

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

    @IBAction func quit(_ sender: AnyObject) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

