//
//  SignUpViewController.swift
//  GleanTn
//
//  Created by John Saba on 9/23/17.
//  Copyright © 2017 Code for Nashville. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct Profile {
    let name: String
    let street: String
    let city: String
    let state: String
    let zip: String
    let phone: String
    let email: String
    let uid: String
    
    var objectRep: [String: String] {
        return [
            "name": name,
            "street": street,
            "city": city,
            "state": state,
            "zip": zip,
            "phone": phone,
            "email": email
        ]
    }
    
    static func profile(json: [String: String]) -> Profile {
        return Profile(name: json["name"]!, street: json["street"]!, city: json["city"]!, state: json["state"]!, zip: json["zip"]!, phone: json["phone"]!, email: json["email"]!, uid: "")
    }
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var fields: [UITextField] {
        return [nameField, streetField, cityField, stateField, zipField, phoneField, emailField, passwordField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createPressed(_ sender: UIButton) {
        
        // Make sure we have the fields
        
        guard let name = nameField.text, name.isEmpty == false else {
            print("### sign up error: need name")
            return
        }
        guard let street = streetField.text, street.isEmpty == false else {
            print("### sign up error: need street")
            return
        }
        guard let city = cityField.text, city.isEmpty == false else {
            print("### sign up error: need city")
            return
        }
        guard let state = stateField.text, state.isEmpty == false else {
            print("### sign up error: need state")
            return
        }
        guard let zip = zipField.text, zip.isEmpty == false else {
            print("### sign up error: need zip")
            return
        }
        guard let phone = phoneField.text, phone.isEmpty == false else {
            print("### sign up error: need phone")
            return
        }
        guard let email = emailField.text, email.isEmpty == false else {
            print("### sign up error: need email")
            return
        }
        guard let password = passwordField.text, password.isEmpty == false else {
            print("### sign up error: need password")
            return
        }
        guard let auth = FIRAuth.auth() else {
            print("### sign up error: couldn't load firebase auth")
            return
        }
        
        // Attempt to create the Firebase user
        
        auth.createUser(withEmail: email, password: password) { [weak self] (usr, error) in
            guard let user = usr, error == nil else {
                print("### sign up error: couldn't create user: \(error!)")
                return
            }
            
            let profile = Profile(name: name, street: street, city: city, state: state, zip: zip, phone: phone, email: email, uid: user.uid)
            self?.createProfile(profile: profile)
        }
    }
    
    func createProfile(profile: Profile) {
        let ref = FIRDatabase.database().reference(withPath: "farmers")
        let childRef = ref.child(profile.uid)
        childRef.setValue(profile.objectRep)
    }
}
