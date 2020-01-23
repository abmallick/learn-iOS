//
//  ViewController.swift
//  CheckList
//
//  Created by Abhinav Kumar on 21/01/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Student"
        //self.view.layer.backgroundColor = UIColor.blue.cgColor
     //   tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      let managedContext = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
      
      do {
        people = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }

    func alert(msg: String) -> Void {
        //to be implemented
    }
    
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Student", message: "Add a new student", preferredStyle: .alert)
        
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        
        alert.textFields![0].placeholder = "Name"
        alert.textFields![1].placeholder = "Age"
        alert.textFields![2].placeholder = "Address"
        alert.textFields![3].placeholder = "RollNo"
        alert.textFields![4].placeholder = "Courses"
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            action in
                                        
          guard let textField = alert.textFields?[0],
            let name = textField.text else {
              return
          }
                                        
        guard let textField2 = alert.textFields?[1],
          let age = textField2.text else {
            return
        }
        guard let textField3 = alert.textFields?[2],
          let course = textField3.text else {
            return
        }
        guard let textField4 = alert.textFields?[3],
          let address = textField4.text else {
            return
        }
        guard let textField5 = alert.textFields?[4],
          let rollNo = textField5.text else {
            return
        }
            
        let student = Student(name: name, age: age, address: address, rollNo: rollNo, course: course)
          self.save(student : student)
          self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(student: Student) {
      
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
        
      let managedContext = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
      let person = NSManagedObject(entity: entity, insertInto: managedContext)
      
        person.setValue(student.getName(), forKeyPath: "name")
        person.setValue(student.getAge(), forKeyPath: "age")
        person.setValue(student.getRollNo(), forKey: "rollNo")
        person.setValue(student.getAddress(), forKey: "address")
        person.setValue(student.getCourses(), forKey: "courses")
      
      do {
        try managedContext.save()
        people.append(person)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }

    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let person = people[indexPath.row]
    let name = person.value(forKeyPath: "name") as? String
    let age = person.value(forKeyPath: "age") as? String
    let address = person.value(forKeyPath: "address") as? String
    let rollNo = person.value(forKeyPath: "rollNo") as? String
    let courses = person.value(forKeyPath: "courses") as? String
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "\(name!), \(age!), \(address!), \(rollNo!), \(courses!)"
    return cell
  }

}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let configuration = UISwipeActionsConfiguration(actions: [UIContextualAction(style:.destructive, title: "Delete", handler: { (action, view, completionHandler) in
            let row = indexPath.row
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
            }
              
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(self.people[row])
            
            do {
              try managedContext.save()
            } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            }
            self.people.remove(at: row)
            self.tableView.reloadData()
            completionHandler(true)

        })])
        return configuration
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {

    let configuration = UISwipeActionsConfiguration(actions: [
    UIContextualAction(style: .normal, title: "Share",
    handler: { (action, view, completionHandler) in
        completionHandler(true)
            })
        ])
    return configuration
    }
}
