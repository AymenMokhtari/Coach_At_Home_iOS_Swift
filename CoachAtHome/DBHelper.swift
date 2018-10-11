//
//  DBHelper.swift
//  CoachAtHome
//
//  Created by Admin on 14.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class  DBHelper {
    
  static  let firsturl = "http://192.168.1.3/pc/api/"
    init() {
        
    }
    
    func registerUser ( user:User , comletion:@escaping (String) ->() , fail:@escaping (String?)-> ()) {
        let params = [
            "email":user.email,
            "first_name":user.firstName ,
            "last_name":user.lastName ,
            "password": user.password ,
            "gender": user.gender,
            "description" :user.description,
            "birthday":user.birthday,
            "city":user.city ,
            "role":user.role
        ]
        print(params)
        
        let postURL = DBHelper.firsturl+"registerUser"
        
        Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{response in
            debugPrint(response)
            
            
            
        }
        

        
    }
    
    func searchByCityName (key:String , complestinoHandler:@escaping ([User])-> () , fail:@escaping ([User])-> ()) {
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        
        var users:[User] = []
        let postURL = DBHelper.firsturl+"searchByCityName/"+key
        
        Alamofire.request(postURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            response in debugPrint(response)
            
            if response.result.value != nil {
                let swiftyJsonVar = JSON(response.result.value!)
                
                if let resData = swiftyJsonVar["users"].arrayObject {
                    arrRes = resData as! [[String:AnyObject]]
                    print("ssssss" )
                      print( arrRes)
                    
                    
                    
        
                    for object in resData {

                        var tmpid = (object as? [String: AnyObject])?["unique_id"]
                        var firstname = (object as? [String: AnyObject])?["first_name"]
                        var lastname = (object as? [String: AnyObject])?["last_name"]
                        var gender = (object as? [String : AnyObject])?["gender"]
                        var email = (object as? [String : AnyObject])?["email"]
                        var description = (object as? [String : AnyObject])?["description"]
                        var rating = (object as? [String : AnyObject])?["avg_rating"]
                        var price = (object as? [String: AnyObject])? ["price"]
                        var city = (object as? [String:AnyObject])? ["city"]
                         var img = (object as? [String:AnyObject])? ["image"]
                        
                        users.append(User(gender: "male", id: tmpid as! String , firstName: firstname as! String, lastName: lastname as! String, email: email as! String, description: description  as! String , rating : rating as! String , price: price as! String , city :city as! String , img:img as! String))
                    }
                    complestinoHandler(users)
                }
            }
        }
    }
    
    
    func getUserById(id: String  , completionHandler:@escaping (User)-> () ,fail:@escaping (String?)->()){
        let rUser:User? = User()
        
  
        let  postURL = DBHelper.firsturl+"getUserById/"+id
        Alamofire.request(postURL, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let user = result as! NSDictionary
                    
                    //if there is no error
           
                        
                        //getting user values
                        let userId = user.value(forKey: "unique_id") as! String
                        let first_name = user.value(forKey: "first_name") as! String
                        let last_name = user.value(forKey: "last_name") as! String
                        let birthday = user.value(forKey: "birthday") as! String
                        let city = user.value(forKey: "city") as! String
                        let description = user.value(forKey: "description") as! String
                        let image = user.value(forKey: "image") as! String
                        let email = user.value(forKey: "email") as! String
                       
                        // let email = user.value(forKey: "email") as! String
                        
                        
                        rUser?.id = userId
                        //  rUser?.email = email
                        rUser?.firstName = first_name
                        rUser?.lastName = last_name
                        rUser?.description = description
                        rUser?.city = city
                        rUser?.img = image
                        rUser?.birthday = birthday
                        rUser?.email  = email
                        completionHandler(rUser!)
                        //switching the screen
                    } else{
                        //error message in case of invalid credential
                        fail("looser")
                        print("login failer!")
                    }
                }
        }
    
    func getUserByEmailAndPassword(email: String , password:String , completionHandler:@escaping (User)-> () ,fail:@escaping (String?)->()){
        let rUser:User? = User()
        
        let params = [
            "email":email,
            "password": password,
            ]
        let  postURL = DBHelper.firsturl+"getUserByEmailAndPassword"
        Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        print("login success")
                        //getting the user from response
                        let user = jsonData.value(forKey: "user") as! NSDictionary
                        
                        //getting user values
                        let userId = user.value(forKey: "id") as! String
                        let first_name = user.value(forKey: "first_name") as! String
                        let last_name = user.value(forKey: "last_name") as! String
                        let role = user.value(forKey: "role") as! String
                       // let email = user.value(forKey: "email") as! String

                        
                        rUser?.id = userId
                      //  rUser?.email = email
                        rUser?.firstName = first_name
                        rUser?.lastName = last_name
                        rUser?.role = role
                        completionHandler(rUser!)
                        //switching the screen
                    } else{
                        //error message in case of invalid credential
       fail("looser")
                        print("login failer!")
                    }
                }
          }
    }
    
    
    func subscribe(idu: String , idt:String ){
        let rUser:User? = User()
        
        let  postURL = DBHelper.firsturl+"subscribe/" + idu + "/" + idt
        Alamofire.request(postURL, method: .post, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
        }
    }
    
    
    
    
    func getPosts (id:String , complestinoHandler:@escaping ([Post])-> () , fail:@escaping ([User])-> ()) {
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        
        var posts:[Post] = []
        let postURL = DBHelper.firsturl+"getPosts/"+id
        
        Alamofire.request(postURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            response in debugPrint(response)
            
            if response.result.value != nil {
                let swiftyJsonVar = JSON(response.result.value!)
                
                if let resData = swiftyJsonVar["posts"].arrayObject {
                    arrRes = resData as! [[String:AnyObject]]
                    print("ssssssdfdfdfdf" )
                    print( arrRes)
                    
                    
                    
                    
                    for object in resData {
                        
                        let contents = (object as? [String: AnyObject])?["content"]
                        let create_date = (object as? [String: AnyObject])?["create_date"]
                        let first_name = (object as? [String: AnyObject])?["first_name"]
                        let last_name = (object as? [String: AnyObject])?["last_name"]
                        let image = (object as? [String: AnyObject])?["image"]
                        let video = (object as? [String: AnyObject])?["video"]
                        
                        

                        posts.append(Post( image    : (image as? String)! , created_date: (create_date as? String)!, content: contents as! String , firstname:(first_name as? String)!  ,lastname:(last_name as? String)! ,  video:(video as? String)!))
                 
                    }
                    complestinoHandler(posts)
                }
            }
        }
    }
    
    
    func upadateUser (user:User , completion:@escaping (String) -> () , fail:@escaping (String) ->() ) {
        let params = [
            "first_name":user.firstName ,
             "last_name":user.lastName,
             "email":user.email,
             "image":user.img ,
             "password":user.password ,
             "birthday":user.birthday ,
             "description":user.description ,
             "city":user.description ,
             ] as [String : Any]
        let postURL = DBHelper.firsturl + "updateUser"
        Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{
            
            response in
            print(response)
        }
        
        
        
    }
    
    
    func checkReservation(idTrainer: String , startDate:String , endDate:String ,  completionHandler:@escaping (String
        )-> () ,fail:@escaping (String)->()){
      
        
        let params = [
            "id_trainer":idTrainer,
            "start_date": startDate,
            "end_date": endDate
            ]
        print(params)
        let  postURL = DBHelper.firsturl+"checkReservation"
        Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print("responssssss")
                print(response)
                debugPrint(response.result.value)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
            
                        print("login success")
                        //getting the user from response
                        let outrange = jsonData.value(forKey: "outrange") as! NSDictionary
                        
                        //getting user values
                        let result = outrange.value(forKey: "result") as! String
             
                        // let email = user.value(forKey: "email") as! String
                        
                   
                        completionHandler(result)
                        //switching the screen
              
                }
        }
    }
    
    
    func addReservation(idTrainer: String ,idUser:String,  startDate:String , endDate:String ,  completionHandler:@escaping (Bool
        )-> () ,fail:@escaping (String)->()){
        
        
        let params = [
            "id_user":idUser,
            "id_trainer":idTrainer,
            "start_date": startDate,
            "end_date": endDate
        ]
        print(params)
        let  postURL = DBHelper.firsturl+"addReservation"
        Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print("responssssss")
                
                debugPrint(response.result.value)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    
                    print("login success")
                    //getting the user from response
            
                    //switching the screen
                    
                }
        }
    }
}
