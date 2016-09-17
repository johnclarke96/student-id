//
//  MainViewController.swift
//  student-id
//
//  Created by John Clarke on 9/17/16.
//  Copyright © 2016 John Clarke. All rights reserved.
//

import UIKit

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
        CoreDataController.sharedInstance.fetchStudentInfo(<#T##entity: String##String#>, email: <#T##String#>)
        let barcodeString: String = "53310"
        let name = "John Clarke"
        let photo: UIImage = UIImage(contentsOfFile: "/Users/jaclarke/Desktop/student-id/photos/jaclarke.jpg")!
        let sName: String = "Regis High School"
        let barcode: Barcode = Barcode(barcode: barcodeString)
        let barcodePhoto = barcode.getBarcode()
        
        studentName.text = name
        studentPhoto.image = photo
        schoolName.text = sName
        studentBarcode.image = barcodePhoto
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

