//
//  HomeViewController.swift
//  CoachAtHome
//
//  Created by Admin on 14.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON
class HomeViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var helper:DBHelper = DBHelper()
    var listCoach:[User] = []
    var selectedUser :User = User()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return listCoach.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coachCell")
        let nameLbl = cell?.viewWithTag(100) as? UILabel
        let  priceLbl = cell?.viewWithTag(150) as? UILabel
        let  ratingLbl = cell?.viewWithTag(200) as? UILabel
        let cityLbl = cell?.viewWithTag(250) as? UILabel
        let imgView = cell?.viewWithTag(300) as? UIImageView
        nameLbl?.text = listCoach[indexPath.row].firstName + " " + listCoach[indexPath.row].lastName
        priceLbl?.text = listCoach[indexPath.row].price + "$ per month"
        ratingLbl?.text = listCoach[indexPath.row].rating
        cityLbl?.text = listCoach[indexPath.row].city
 
        let url = URL(string: DBHelper.firsturl + "imgs/"+listCoach[indexPath.row].img )
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        imgView?.image = UIImage(data: data!)
        return cell! 
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // retriev current conected id
        var id:String =  UserDefaults.standard.string(forKey: "id")!
        print("connected id" + id)
        var helper:DBHelper = DBHelper()
     
        helper.searchByCityName(key: "dd", complestinoHandler: {
            (listuser) in
            
            self.listCoach  = listuser
        
            print("sdfsffds")
            print(self.listCoach)
            self.tableView.reloadData()
        }, fail: {
            (error) in
            
        })

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = listCoach[indexPath.row]
  
        performSegue(withIdentifier: "ToTProfile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToTProfile"{
            if let destinationVC = segue.destination as? TrainerProfilViewController {
                destinationVC.user = selectedUser
             
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        helper.searchByCityName(key: searchText, complestinoHandler: {
            (listuser) in
            
            self.listCoach  = listuser
            
            print("sdfsffds")
            print(self.listCoach)
            self.tableView.reloadData()
        }, fail: {
            (error) in
            
        })    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
