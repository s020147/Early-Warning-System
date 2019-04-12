//
//  ViewController.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/8/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import SVProgressHUD
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var accessValid : Bool = false
    var ref: DatabaseReference!
    var locationManager = CLLocationManager()
    var userText : String = ""
    var passwordText: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text == ""){
        return false
        }
        return true
    }

    func setupForm(){

    }
//fix login, this is wrong
    @IBAction func loginAction(_ sender: UIButton) {
        userText = userTextField.text!
        passwordText = passwordTextField.text!
        Auth.auth().signIn(withEmail: userText, password: passwordText, completion: { (result,error) in
            if error == nil{
                if let user = result?.user{
                    print("sign in success")
                    self.accessValid = true
                }
            }else{
                print(error?.localizedDescription)
            }
        })
        }
            
        
    
    @IBAction func toSignUpBtn(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController{
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(accessValid == false){
            return false
        }
        return true
    }


}

