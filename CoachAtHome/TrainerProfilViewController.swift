//
//  TrainerProfilViewController.swift
//  CoachAtHome
//
//  Created by Admin on 15.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Cosmos
class TrainerProfilViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var scoreRating: CosmosView!
    
  /*
    
    @IBAction func checkAvailablitytn(_ sender: UIButton) {
        
          performSegue(withIdentifier: "toBook", sender: nil)
        
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBook"{
            if let destinationVC = segue.destination as? BookCoachViewController {
                destinationVC.user = self.user
                
                
            }
        }
    }
    
    
    var id:String = ""
    @IBOutlet weak var commentTxt: UITextView!
  
 
    
    @IBAction func addCommmentBtn(_ sender: UIButton) {
        
        addComment(id_user: id, id_trainer: user.id, content: commentTxt.text)
        getComments(id: user.id)
    }
    @IBOutlet weak var tableViewComment: UITableView!
    var commentsList:[[String:AnyObject]] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return commentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let    cell  = tableView.dequeueReusableCell(withIdentifier: "CommentCell")
        
        let username = cell?.viewWithTag(600) as! UILabel
        let date  = cell?.viewWithTag(650) as!UILabel
        let content = cell?.viewWithTag(700) as! UILabel
        let image = cell?.viewWithTag(550) as! UIImageView
        date.text =  (commentsList[indexPath.row] as [String:AnyObject]) ["date"] as! String
        content.text = (commentsList[indexPath.row] as [String:AnyObject])  ["content"] as! String
        var cont = (commentsList[indexPath.row] as [String:AnyObject])  ["content"] as! String
        
        var img =  (commentsList[indexPath.row] as [String:AnyObject])  ["image"] as! String
        
        let url = URL(string: DBHelper.firsturl + "imgs/"+img )
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise
        image.image = UIImage(data: data!)
        image.layer.borderWidth = 1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = (image.frame.size.width)/2
        image.clipsToBounds = true
            print("sssssssdddsds" + cont)
        return cell!
    }
    

    var user:User = User()
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var descriptiontext: UITextView!
    @IBAction func flollowBtn(_ sender: UIButton) {
        var id:String =  UserDefaults.standard.string(forKey: "id")!

        var helper:DBHelper  = DBHelper()
        helper.subscribe(idu: id, idt: user.id
        )
        
        

        
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        id = UserDefaults.standard.string(forKey: "id")!
        self.scoreRating.didTouchCosmos = didTouchCosmos

         getComments(id: user.id)
        print("profile page")
        print(user.firstName)
        
        name.text = user.firstName + " " + user.lastName
        
        let url = URL(string: DBHelper.firsturl + "imgs/"+user.img )
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check /
        profileImg?.image = UIImage(data: data!)
        
        
    
        score.text = user.rating
        descriptiontext.text = user.description
        city.text = user.city
        
        profileImg.layer.borderWidth = 1.0
        profileImg.layer.masksToBounds = false
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        scoreRating.rating = Double(user.rating)!
        
        
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
    
    func getComments (id:String) {
        
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        
     
        let postURL = DBHelper.firsturl+"getComments/"+id
        
        Alamofire.request(postURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            response in debugPrint(response)
            
            if response.result.value != nil {
                let swiftyJsonVar = JSON(response.result.value!)
                
                if let resData = swiftyJsonVar["comments"].arrayObject {
                    arrRes = resData as! [[String:AnyObject]]
                    print("ssssss" )
                    print( arrRes)
                    
                   
                    self.commentsList = arrRes
                    print(self.commentsList)
                    self.tableViewComment.reloadData()
                }
            }
        }
    }
    
    
    
    
    func addComment ( id_user:String , id_trainer:String , content:String) {
        let params = [
            "id_user":id_user,
            "id_trainer":id_trainer ,
            "content":content
        ]
        print(params)
        
        let postURL = DBHelper.firsturl+"addComment"
        
        Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{response in
            debugPrint(response)
            
            self.tableViewComment.reloadData()
            
        }
        
        
        
    }
    
    func addRating ( id_user:String , rating:Double ) {
        let params = [
            "id_user":id_user,
            "rating":rating
            ] as [String : Any]
        print(params)
        
        let postURL = DBHelper.firsturl+"addRating"
        
        Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{response in
            debugPrint(response)
            
            self.tableViewComment.reloadData()
            
        }
        
        
        
    }
    
    
    private func didTouchCosmos(_ rating: Double) {
        print("touched")
           self.addRating(id_user: self.user.id, rating: rating)
    }

}
