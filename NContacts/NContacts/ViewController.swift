//
//  ViewController.swift
//  NContacts
//
//  Created by Abhinav Kumar on 22/01/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController, CNContactPickerDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    var contactStore = CNContactStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkAccess()
    }
    @IBAction func addContact(_ sender: Any) {
        let contact = CNMutableContact()
        contact.givenName = name.text!
        let phoneNo = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: phone.text!))
        contact.phoneNumbers = [phoneNo]
        
        let emailId = CNLabeledValue(label: CNLabelHome, value: phone.text! as NSString)
        contact.emailAddresses = [emailId]
        
        let request = CNSaveRequest()
        request.add(contact, toContainerWithIdentifier: nil)
        do{
          try contactStore.execute(request)
            name.text = ""
            phone.text = ""
            email.text = ""
            let alert = UIAlertController(title: "Success!", message: "Contact has been successfully added!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
          print("Successfully stored the contact")
        } catch let err{
            let alert = UIAlertController(title: "Failure!", message: "Failed to add contact", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
              self.present(alert, animated: true)
          print("Failed to save the contact. \(err)")
        }
        
    }
    
    @IBAction func showContacts(_ sender: Any) {
        let picker = CNContactPickerViewController()
        
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func checkAccess () -> Void {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
          
        switch authorizationStatus{
        case .notDetermined, .denied:
            contactStore.requestAccess(for: .contacts){succeeded, err in
            guard err == nil && succeeded else{
              return
            }
          }
        default:
          print("Not handled")
        }
    }
    
}

