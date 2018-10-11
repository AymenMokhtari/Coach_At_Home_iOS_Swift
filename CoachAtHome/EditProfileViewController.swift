//
//  EditProfileViewController.swift
//  CoachAtHome
//
//  Created by Admin on 18.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
class EditProfileViewController: UIViewController ,UIImagePickerControllerDelegate  , UINavigationControllerDelegate{


    @IBOutlet weak var firstnameLbl: UITextField!
    @IBOutlet weak var lastnameLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var confirmPassLbl: UITextField!
    @IBOutlet weak var descLbl: UITextView!
    @IBOutlet weak var cityLbl: UITextField!
    @IBOutlet weak var birthdayLbl: UITextField!
    
    @IBAction func updateBtn(_ sender: UIButton) {
      var helper:DBHelper = DBHelper()
        var tmpUser:User
        tmpUser = User()
        tmpUser.firstName = firstnameLbl.text!
        tmpUser.lastName = lastnameLbl.text!
        tmpUser.email = emailLbl.text!
        tmpUser.password = passwordLbl.text!
        tmpUser.description = descLbl.text
        tmpUser.city = cityLbl.text!
        tmpUser.birthday = birthdayLbl.text!
        
        helper.upadateUser(user: tmpUser, completion: {
            result in
            
            self.postImageToDB(image: self.imageProfile.image!)
            
        }, fail: {
            failer in
            
        })
        
    }
    @IBAction func imgUploadBtn(_ sender: UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
  
        

    
   
    @IBOutlet weak var imageProfile: UIImageView!
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageData:Data = UIImagePNGRepresentation(image_data!)!
        let imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        imageProfile.image = image_data
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var helper:DBHelper = DBHelper()
        var id:String = UserDefaults.standard.string(forKey: "id")!
        helper.getUserById(id: id, completionHandler: {
            user in
            
            self.firstnameLbl.text = user.firstName
            self.lastnameLbl.text = user.lastName
            self.emailLbl.text  = user.email
            self.descLbl.text = user.description
            self.cityLbl.text = user.city
            self.birthdayLbl.text = user.birthday
            
       
            
            let url = URL(string: DBHelper.firsturl + "imgs/"+user.img )
            
            self.downloadImage(url: url!)


            
            
            
            

        }, fail: {
            fail in
            
            
            
            
        })
        // Do any additional setup after loading the view.
        
        let date = NSDate()
        let calendar = NSCalendar.current
let anchorComponents = calendar.dateComponents([.day, .month, .year, .hour], from: date  as Date)
        let hour = anchorComponents.hour
        let minutes = anchorComponents.minute
        
        
        
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
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
         
                
                
                
                self.imageProfile?.image = UIImage(data: data)
                self.imageProfile?.layer.borderWidth = 1.0
                self.imageProfile?.layer.masksToBounds = false
                self.imageProfile?.layer.borderColor = UIColor.white.cgColor
                self.imageProfile?.layer.cornerRadius = (self.imageProfile?.frame.size.width)!/2
               self.imageProfile?.clipsToBounds = true
            
            }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func postImageToDB(image : UIImage) {
        
        let imagePostUrlStr =  "http://192.168.1.3/pc/api/upload_image.php"
        
        guard let imageData = UIImagePNGRepresentation(image) else {
            return
        }
        //want to save my image to this directory which is inside root
        let params = ["path" : "imgs/"]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            
            multipartFormData.append(imageData, withName: "fileToUpload", fileName: "ddd.jpg", mimeType: "image/jpeg")
        }, to:imagePostUrlStr)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                print("mlkjmlkj")
                upload.responseString { response in
                    print("printing response string")
                    print(response.value as Any)
                    print(response)
                    print(response.result)
                    
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError.localizedDescription)
            }
            
        }
        
        
    }
    
    
}
