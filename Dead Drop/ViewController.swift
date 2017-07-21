//
//  ViewController.swift
//  Dead Drop
//
//  Created by Adrien Maranville on 7/20/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet var txtBoxUserName: UITextField!
    @IBOutlet var lblErrorMessage: UILabel!
    @IBOutlet var btnLogInSignUp: UIButton!
    @IBAction func btnLogInSignUpPressed(_ sender: Any) {
        if txtBoxUserName.text == "" {
            lblErrorMessage.text = "Please enter a username."
        } else {
            PFUser.logInWithUsername(inBackground: txtBoxUserName.text!, password: "secret", block: { (user, error) in
                if error != nil {
                    let user = PFUser()
                    user.username = self.txtBoxUserName.text
                    user.password = "secret"
                    
                    user.signUpInBackground(block: { (success, error) in
                        if let error = error as NSError? {
                            var errorMessage = "Sign up failed - try agian later."
                            if let errorString = error.userInfo["error"] as? String {
                                errorMessage = errorString
                            }
                            self.lblErrorMessage.text = errorMessage
                        } else {
                             self.performSegue(withIdentifier: "showUsersSegue", sender: self)
                        }
                    })
                } else {
                    print("logged in")
                    self.performSegue(withIdentifier: "showUsersSegue", sender: self)
                }
            })
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUsersSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
