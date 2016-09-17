//
//  LoginViewController.swift
//  student-id
//
//  Created by John Clarke on 9/17/16.
//  Copyright © 2016 John Clarke. All rights reserved.
//

import Foundation
import UIKit
class LoginViewController: UIViewController {
    
    var email: String = ""
    
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // if first login, call API to gather student information
        appLabel.text = "sid"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: AnyObject) {
        // take in username and password, trim whitespace and newline characters
        let emailString = emailText.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let passwordString = passwordText.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // password range: 8-20 characters
        let pLo = 8
        let pHi = 20
        
        // in the event of a validation failure, a UIAlertAction will present itself and clear the username and password fields
        var message = ""
        
        if (!Validation.isValidEmail(testStr: emailString)) {
            message += "Please be sure your email is well-formed.\n"
        }
        
        if (!Validation.isAlphaNumeric(passwordString) || !Validation.isInRange(passwordString, lo: pLo, hi: pHi)) {
            message += "Please be sure your password is alphanumeric and within 8 and 20 characters.\n"
        }
        
        if (message.characters.count > 0) {
            let loginIssue = UIAlertController(title: "Login Issue", message: message, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            loginIssue.addAction(action)
            self.present(loginIssue, animated: true, completion: { () -> Void in
                self.emailText.text = ""
                self.passwordText.text = ""
            })
        }
        else {
            // check coredata if ID saved with entered email; if not call API, otherwise don't
            let data = CoreDataController.sharedInstance.fetchStudentInfo("User", email: emailString)
            self.email = emailString
            if (data.isEmpty) {
                let http = HTTPRequests(host: "18.189.104.176", port: "5000", resource: "login", params: ["email": emailString, "password" : passwordString])
                http.POST({ (json) -> Void in
                    let success = json["success"] as! Int
                    let data = json["data"] as! [String:AnyObject]
                    if (success == 1) {
                        // save gathered information to coredata
                        let firstName = data["first_name"] as! String
                        let lastName = data["last_name"] as! String
                        let studentID = data["student_id"] as! String
                        let imagePath = data["image_path"] as! String
                        let schoolName = data["school_name"] as! String
                        let imageIdentifier = schoolName + studentID + ".jpg"
                        
                        OperationQueue.main.addOperation {
                            self.emailText.text = ""
                            self.passwordText.text = ""
                            
                            let imageURL = "18.189.104.176" + ":" + "5000" + "/image?path=" + imagePath
                            let image = Image(imageURL: imageURL, identifier: imageIdentifier)
                            image.getImageAndSaveToDisk( { (iosPath) -> Void in
                                let data = ["firstName" : firstName, "lastName" : lastName, "schoolName" : schoolName, "studentID" : studentID, "imagePath" : iosPath, "email" : emailString]
                                CoreDataController.sharedInstance.saveToCoreData("User", data: data)
                                Cache.initCache(firstName: firstName, lastName: lastName, studentID: studentID, schoolName: schoolName, imagePath: iosPath, barcode: studentID)
                            })
                            self.performSegue(withIdentifier: "to-main", sender: self)
                        }
                    } else {
                        let error = data["error"] as! String
                        let loginAlert = UIAlertController(title: "Login Issue", message: error, preferredStyle: UIAlertControllerStyle.alert)
                        let loginAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        loginAlert.addAction(loginAction)
                        OperationQueue.main.addOperation {
                            self.present(loginAlert, animated: true, completion: { () -> Void in
                                self.emailText.text = ""
                                self.passwordText.text = ""
                            })
                        }
                    }
                })
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to-main" {
            let destination = segue.destination as! MainViewController
            destination.email = self.email
        }
    }
    
    // clicking out of email, password fields dismisses the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
