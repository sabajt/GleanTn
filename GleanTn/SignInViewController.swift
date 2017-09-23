//
//  SignInViewController.swift
//  GleanTn
//
//  Created by John Saba on 9/23/17.
//  Copyright © 2017 Code for Nashville. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference(withPath: "farmers")
        ref.queryOrderedByKey().observe(.value) { (snapshot) in
            print(snapshot.value!)
        }
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
        auth.signIn(withEmail: email, password: password) { (usr, error) in
            guard let user = usr, error == nil else {
                print("### login error: no user found with email: \(email), firebase error: \(error!)")
                return
            }
            print("### successful login with user: \(user)")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "SubmitViewController") as? SubmitViewController else {
                return
            }
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
    }
}

