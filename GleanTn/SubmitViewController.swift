//
//  SubmitViewController.swift
//  GleanTn
//
//  Created by John Saba on 9/23/17.
//  Copyright © 2017 Code for Nashville. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SubmitViewController: UIViewController {
    
    var user: FIRUser?
    var observerToken: UInt?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            let ref = FIRDatabase.database().reference(withPath: "farmers").child(user.uid)
            observerToken = ref.queryOrderedByKey().observe(.value, with: { (snapshot) in
                guard let data = snapshot.value as? [String: String] else {
                    return
                }
                let profile = Profile.profile(json: data)
            })
        }
    }
}
