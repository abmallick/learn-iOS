//
//  Student.swift
//  CheckList
//
//  Created by Abhinav Kumar on 21/01/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import Foundation

class Student : Equatable {
    static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs.getRollNo() == rhs.getRollNo() && lhs.getName() == rhs.getName()
    }
    
    //name, age, address, rollNo, course
    private var name : String
    private var age : String
    private var address : String
    private var rollNo : String
    private var course : String
    
    init(name: String, age : String, address : String, rollNo : String, course : String) {
        self.name = name
        self.age = age
        self.address = address
        self.rollNo = rollNo
        self.course = course
    }
    
    func getName() -> String {
        return name
    }
    
    func getAge() -> String {
        return age
    }
    
    func getAddress() -> String {
        return address
    }
    
    func getRollNo() -> String {
        return rollNo
    }
    
    func getCourses() -> String {
        return course
    }
    
    public var description : String {
       "name = \(name), age = \(age), address = \(address), rollNo = \(rollNo), course = \(course)"
    }
}
