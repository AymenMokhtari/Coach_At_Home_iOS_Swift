//
//  ViewController.swift
//  CoachAtHome
//
//  Created by Admin on 11/04/2018.
//  Copyright © 2018 Admin. All

import UIKit
import  Alamofire

class ViewController: UIViewController {
    let defaultValues = UserDefaults.standard

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBAction func login(_ sender: UIButton) {
        let helper:DBHelper? = DBHelper()
        
        helper?.getUserByEmailAndPassword(email: emailTxt.text!, password: passwordTxt.text!, completionHandler: { (user) in
            
            if(user.role == "Client") {
                
                  self.performSegue(withIdentifier: "toHome", sender: self)
            }else {
                self.performSegue(withIdentifier: "toCoachHome", sender: self)
                
            }
          
            print("\nSuccess. Response received...: " + user.lastName)
            UserDefaults.standard.set(user.id, forKey: "id")
            
            
            
            
        }) { (error ) in
            print(error ?? "false")
            let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
        
    
            
            
        
       
        
        /*
        let params = [
            "email":emailTxt.text,
            "password": passwordTxt.text,
            ]
        let  postURL = "http://192.168.1.6/pc/api/getUserByEmailAndPassword"
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
                        
                        //saving user values to defaults
                        self.defaultValues.set(userId, forKey: "id")
                        self.defaultValues.set(first_name, forKey: "first_name")
                        self.defaultValues.set(last_name, forKey: "last_name")
                        
                        //switching the screen
                        self.performSegue(withIdentifier: "toHome", sender: self)
                        

                        self.dismiss(animated: false, completion: nil)
                    }else{
                        //error message in case of invalid credential
                        let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true)
                        print("login failer!")
                    }
                }
        }
        */
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
   


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

