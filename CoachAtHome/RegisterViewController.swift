//
//  RegisterViewController.swift
//  CoachAtHome
//
//  Created by Admin on 14.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import DatePickerDialog
class RegisterViewController: UIViewController {

    @IBOutlet weak var firstnameTxt: UITextField!
    
    @IBOutlet weak var lastnameTxt: UITextField!
    
    @IBOutlet weak var birthdayTxt: UITextField!
    
  
    @IBAction func birthdayPicker(_ sender: UITextField) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-mm-yyyy"
                print(formatter.string(from: dt    ))
                self.birthdayTxt.text = formatter.string(from: dt)
                //    self.textField.text = formatter.string(from: dt)
            }
        }
    }
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    @IBOutlet weak var roleSC: UISegmentedControl!
    @IBOutlet weak var ganderRadio: UISegmentedControl!
    @IBOutlet weak var descriptionTxt: UITextField!
    
    
    let helper:DBHelper = DBHelper()
    @IBAction func registerBtn(_ sender: UIButton) {
  
       var user:User = User()
        user.firstName = firstnameTxt.text!
        user.lastName = lastnameTxt.text!
        user.email = emailTxt.text!
        user.password = passwordTxt.text!
        user.birthday = birthdayTxt.text!
        user.description = descriptionTxt.text!
        user.city = "Unknown"
        user.gender = ganderRadio.titleForSegment(at: ganderRadio.selectedSegmentIndex)!
        user.role = roleSC.titleForSegment(at: roleSC.selectedSegmentIndex)!
        
        helper.registerUser(user: user, comletion: { (suceess) in
            print(suceess)
            
            
            
        }, fail: { (error) in
            print(error)
            
            
            
            
        })
        
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helper.searchByCityName(key: "dd", complestinoHandler: {
            (listuser) in
        //    print(listuser)
            
        }, fail: { (error) in
            print(error)
            
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
