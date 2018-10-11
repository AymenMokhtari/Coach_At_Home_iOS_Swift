//
//  CoachHomeViewController.swift
//  CoachAtHome
//
//  Created by Admin on 18.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import  Alamofire
class CoachHomeViewController: UIViewController  ,UIImagePickerControllerDelegate  , UINavigationControllerDelegate{

    @IBOutlet weak var image: UIImageView!
    @IBAction func chooseImgBtn(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadImageBtn(_ sender: Any) {
        postImageToDB(image: self.image.image!)
    }
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
    
 
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageData:Data = UIImagePNGRepresentation(image_data!)!
        let imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        image.image = image_data
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
