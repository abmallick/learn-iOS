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
    
    func alert(msg: String) -> Void {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func validName(name: String) -> String {
        let range = NSRange(location: 0, length: name.count)
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z]")
        
        if regex.firstMatch(in: name, options: [], range: range) != nil {
            return name
        }
        else {
            alert(msg: "Invalid Name")
            return "err"
        }
    }
    
    func validPhone(phone: String) -> String {
        let range = NSRange(location: 0, length: phone.count)
        let regex = try! NSRegularExpression(pattern: "[6-9][0-9]{9}")
        
        if regex.firstMatch(in: phone, options: [], range: range) != nil {
            return phone
        }
        else {
            alert(msg: "Invalid Phone")
            return "err"
        }
    }
    
    func validEmail(email: String) -> String {
        let range = NSRange(location: 0, length: email.count)
        let regex = try! NSRegularExpression(pattern: "[0-9a-zA-Z]+@[a-z]+.[a-z]+")
        
        if regex.firstMatch(in: email, options: [], range: range) != nil {
            return email
        }
        else {
            alert(msg: "Invalid Email")
            return "err"
        }
    }
    
    @IBAction func addContact(_ sender: Any) {
        let contact = CNMutableContact()
        var cName: String?
        var cPhone: String?
        var cEmail: String?
        
        if let temp = name.text {
            cName = validName(name: temp)
        }
        
        if let temp = phone.text {
            cPhone = validPhone(phone: temp)
        }
        
        if let temp = email.text {
            cEmail = validEmail(email: temp)
        }
        
        if cName == nil || cEmail == nil || cPhone == nil {
            alert(msg: "Missing inputs!")
            return
        }
        
        if cName == "err" || cEmail == "err" || cPhone == "err"{
           return
        }
        
        contact.givenName = cName!
        let phoneNo = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: cPhone!))
        contact.phoneNumbers = [phoneNo]
        
        let emailId = CNLabeledValue(label: CNLabelHome, value: cEmail! as NSString)
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

