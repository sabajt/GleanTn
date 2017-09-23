//
//  SubmitViewController.swift
//  GleanTn
//
//  Created by John Saba on 9/23/17.
//  Copyright © 2017 Code for Nashville. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseDatabase
import FirebaseAuth

class SubmitViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var user: FIRUser?
    var observerToken: UInt?
    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            let ref = FIRDatabase.database().reference(withPath: "farmers").child(user.uid)
            observerToken = ref.queryOrderedByKey().observe(.value, with: { [weak self] (snapshot) in
                guard let data = snapshot.value as? [String: String] else {
                    return
                }
                self?.profile = Profile.profile(json: data)
            })
        }
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["gleantn@endhunger.org"])
        mailComposerVC.setSubject("TAKE MY VEGGIE!")
        
        if let profile = profile {
            mailComposerVC.setMessageBody("Name: \(profile.name), Street: \(profile.street), City: \(profile.city), State: \(profile.state), Zip: \(profile.zip), Phone: \(profile.phone), Preferred Email: \(profile.email)", isHTML: false)
        }
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        print("### can't send mail!")
//        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
