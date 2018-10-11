//
//  PostsViewController.swift
//  CoachAtHome
//
//  Created by Admin on 15.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import  MediaPlayer
import Alamofire
import SwiftyJSON
class PostsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    var selectedPost:Post = Post()
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        
        
        if  isSlideMenuHidden {
            sideMenuConstrainr.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.layoutIfNeeded()
            })
        }else {
            sideMenuConstrainr.constant = -140
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.layoutIfNeeded()
            })
        }
        isSlideMenuHidden = !isSlideMenuHidden
        
    }
    
    @IBOutlet weak var sideMenuConstrainr: NSLayoutConstraint!
    var isSlideMenuHidden = true
    
    @IBOutlet weak var tabelView: UITableView!
    
  
    
    
    
    var listPosts:[Post] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  listPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell")
        
        let  image =   cell?.viewWithTag(350) as? UIImageView
        let usernameLbl = cell?.viewWithTag(400) as? UILabel
        let dateLbl = cell?.viewWithTag(450) as? UILabel
        let contentText = cell?.viewWithTag(500) as? UITextView
        let videoView = cell?.viewWithTag(600) as? UIView
        
       usernameLbl?.text = listPosts[indexPath.row].fistname + " " + listPosts[indexPath.row].lastname
        dateLbl?.text  = listPosts[indexPath.row].created_date
        contentText?.text = listPosts[indexPath.row].content
        
        
       
        let url = URL(string: DBHelper.firsturl + "imgs/"+listPosts[indexPath.row].image )
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise
        image?.image = UIImage(data: data!)
        image?.layer.borderWidth = 1.0
        image?.layer.masksToBounds = false
        image?.layer.borderColor = UIColor.white.cgColor
        image?.layer.cornerRadius = (image?.frame.size.width)!/2
        image?.clipsToBounds = true
        
        
        
        
        
        
         var moviePlayer:MPMoviePlayerController!
        
        let videoUrl:NSURL = NSURL(string: DBHelper.firsturl+"videos/30/"+listPosts[indexPath.row].video)!
        
        moviePlayer = MPMoviePlayerController(contentURL: videoUrl as URL?)
        moviePlayer.view.frame = (videoView?.bounds)!
        videoView?.addSubview(moviePlayer.view)
        
        moviePlayer.isFullscreen = false
        
        moviePlayer.controlStyle = MPMovieControlStyle.embedded
        
        
        
 //       moviePlayer.stop()
        
    //    moviePlayer.pause()
        moviePlayer.isFullscreen = false

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = listPosts[indexPath.row]
        
        performSegue(withIdentifier: "toOnePost", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOnePost"{
            if let destinationVC = segue.destination as? OnePostViewController {
                destinationVC.post = selectedPost
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  blurView.layer.cornerRadius = 15
        sideMenuConstrainr.constant = -140
        let id:String = UserDefaults.standard.string(forKey: "id")!
        getUserById(id: id)
        let helper:DBHelper = DBHelper()
        helper.getPosts(id: id , complestinoHandler:{
            (listuser) in
            
            self.listPosts  = listuser
            
            print("hello")
          //  print(self.listPosts[0].content)
            print("done")
            self.tabelView.reloadData()
        }, fail: {
            (error) in
            
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
    
    func getUserById (id:String) {
        
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        
        
        let postURL = DBHelper.firsturl+"getUserById/"+id
        
        Alamofire.request(postURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            response in debugPrint(response)
            
            
            
            
            if let result = response.result.value {
                let user = result as! NSDictionary
                
                //if there is no error
                
                
                //getting user values
                let image = user.value(forKey: "image") as! String
                let firstname = user.value(forKey: "first_name") as! String
                let lastname = user.value(forKey: "last_name") as! String
                self.username.text = firstname+" "+lastname
                let url = URL(string: DBHelper.firsturl + "imgs/"+image)
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise
                self.userImage?.image = UIImage(data: data!)
                self.userImage?.layer.borderWidth = 1.0
                self.userImage?.layer.masksToBounds = false
                self.userImage?.layer.borderColor = UIColor.white.cgColor
                self.userImage?.layer.cornerRadius = (self.userImage?.frame.size.width)!/2
                self.userImage?.clipsToBounds = true
                
            
        
        }
    }

}
}
