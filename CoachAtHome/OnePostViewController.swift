//
//  OnePostViewController.swift
//  CoachAtHome
//
//  Created by Admin on 16.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MediaPlayer
class OnePostViewController: UIViewController {
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var postUser: UILabel!
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var content: UITextView!
    
    var moviePlayer:MPMoviePlayerController!
 
    var post:Post = Post()
    @IBOutlet weak var movieView: UIView!
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       postUser.text = post.fistname + " " +  post.lastname
        postDate.text = post.created_date
        content.text = post.content
        let url = URL(string: DBHelper.firsturl + "imgs/"+post.image )
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise
        userImg?.image = UIImage(data: data!)
        userImg?.layer.borderWidth = 1.0
        userImg?.layer.masksToBounds = false
        userImg?.layer.borderColor = UIColor.white.cgColor
        userImg?.layer.cornerRadius = (userImg?.frame.size.width)!/2
        userImg?.clipsToBounds = true
        
        
        
        let videoUrl:NSURL = NSURL(string: DBHelper.firsturl+"videos/"+post.video)!
        
        moviePlayer = MPMoviePlayerController(contentURL: videoUrl as URL?)
        moviePlayer.view.frame = movieView.bounds
        movieView.addSubview(moviePlayer.view)
        
        moviePlayer.isFullscreen = true
        
        moviePlayer.controlStyle = MPMovieControlStyle.embedded
        
    }
    
    

}
