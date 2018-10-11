//
//  User.swift
//  CoachAtHome
//
//  Created by Admin on 14.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
class  User {
    var id: String = ""
    var firstName:String = ""
    var lastName:String = ""
    var email:String = ""
    var password:String = ""
    var gender:String = ""
    var description:String = ""
    var rating :String = ""
    var price :String = ""
    var city :String = ""
    var img:String = ""
    var birthday:String = ""
    var role:String = ""
    init(gender:String = "",  id:String = "" ,  firstName:String = "" , lastName:String = "", email:String = "" , password:String = ""  , description:String = "" , rating:String = "" , price:String = "" , city:String = "" , img:String = "") {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.gender = gender
        self.description = description
        self.rating = rating
        self.price = price
        self.city = city
        self.img  = img
    }
}
