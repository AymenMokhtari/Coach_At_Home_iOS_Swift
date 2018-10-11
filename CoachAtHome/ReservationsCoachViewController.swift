//
//  ReservationsCoachViewController.swift
//  CoachAtHome
//
//  Created by Admin on 23.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import  SwiftyJSON
class ReservationsCoachViewController: UIViewController {

    
 var ranges:[[String:AnyObject]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

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
    func getRanges (id:String) {
        
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        
        
        let postURL = DBHelper.firsturl+"getReservation/"+id
        
        Alamofire.request(postURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            response in debugPrint(response)
            
            if response.result.value != nil {
                let swiftyJsonVar = JSON(response.result.value!)
                
                if let resData = swiftyJsonVar["reservations"].arrayObject {
                    arrRes = resData as! [[String:AnyObject]]
                    print("ssssss" )
                    print( arrRes)
                    
                    
                    self.ranges = arrRes
                    print(self.ranges)
                 //self.tableView.reloadData()
                    
                    
                }
            }
        }
    }
}
