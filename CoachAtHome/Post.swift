//
//  Post.swift
//  CoachAtHome
//
//  Created by Admin on 15.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
class Post {
    var image:String = ""
    var created_date:String = ""
    var content:String = ""
    var fistname:String = ""
    var lastname:String = ""
    var video:String  = ""
    init(image:String = "" , created_date:String = "" , content:String = "" , firstname:String = "" , lastname:String = "" , video:String = "") {
        self.image = image
        self.created_date = created_date
        self.content = content
        self.fistname = firstname
        self.lastname = lastname
        self.video = video
    }
    
    
}
