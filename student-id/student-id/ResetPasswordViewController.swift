//
//  ResetPasswordViewController.swift
//  student-id
//
//  Created by John Clarke on 9/18/16.
//  Copyright © 2016 John Clarke. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    

    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func resetPassword(_ sender: AnyObject) {
        let emailString = email.text!
        if (Validation.isValidEmail(testStr: emailString)) {
            let message: String = "An email to change your password will be sent to " + email.text! + "."
            let alert = UIAlertController(title: "Request Password Change", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: {
                let params = ["email": self.email.text!]
                let http = HTTPRequests(host: "52.27.186.224", port: "5000", resource: "password_reset", params: params)
                http.POST({ (json) -> Void in
                    let message1 = json["message"] as! String
                    let alert1 = UIAlertController(title: "Request Processed", message: message1, preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert1.addAction(action1)
                    self.present(alert1, animated: true, completion: nil)
                })
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
