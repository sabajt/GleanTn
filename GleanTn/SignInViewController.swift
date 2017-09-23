//
//  SignInViewController.swift
//  GleanTn
//
//  Created by John Saba on 9/23/17.
//  Copyright © 2017 Code for Nashville. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        
        guard let email = emailField.text, email.isEmpty == false else {
            print("### login error: need email")
            return
        }
        guard let password = passwordField.text, password.isEmpty == false else {
            print("### login error: need password")
            return
        }
        guard let auth = FIRAuth.auth() else {
            print("### login error: couldn't load firebase auth")
            return
        }
        auth.signIn(withEmail: email, password: password) { (user, error) in
            guard let usr = user, error == nil else {
                print("### login error: no user found with email: \(email), firebase error: \(error!)")
                return
            }
            print("### successful login with user: \(usr)")
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
    }
}

