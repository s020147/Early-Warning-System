//
//  SignUpViewController.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/8/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Eureka

class SignUpViewController: FormViewController{
    
    var ref: DatabaseReference!
    var fNameTxt: String?
    var lNameTxt: String?
    var emailTxt: String?
    var pwdTxt: String?
    var cPwdTxt: String?
    var genderTxt: String?
    
    @IBOutlet weak var agreeBtnOut: UIButton!
    @IBOutlet weak var recieveEmailOut: UIButton!
    @IBOutlet weak var signupTableView: UITableView!
    var agree:Bool = false
    var recieveEmail:Bool = false
    let FBManager = FirebaseAPI.shared
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        title = "SIGN UP"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        signupTableView.isScrollEnabled = false
        signupTableView.tableFooterView = UIView()
        
        form
        +++ Section()
        <<< TextRow(){ row in
                row.title = "First Name"
                row.placeholder = "Enter first name here"
        }
        .cellUpdate({
            cell, row in
            self.fNameTxt = cell.textField.text
        })
        <<< TextRow(){ row in
                row.title = "Last Name"
                row.placeholder = "Enter last name here"
        }
        .cellUpdate({cell, row in
            self.lNameTxt = cell.textField.text
        })
            <<< EmailRow(){ row in
                row.title = "Email"
                row.placeholder = "Enter Email Here"
        }
        .cellUpdate({cell, row in
            self.emailTxt = cell.textField.text
        })
        
        
        
        
    }
    @IBAction func agreementBtn(_ sender: UIButton) {
        //if you figure out deselect and select switch this, if not use flag -dt
        switch sender.tag {
        case 1:
            agree = !agree
            if(agree == true){
                agreeBtnOut.imageView?.image =  UIImage.init(named: "check")
                
                print(agreeBtnOut.imageView?.image)
            }else{
                agreeBtnOut.imageView?.image = UIImage.init(named: "uncheck")
            }
        case 2:
            recieveEmail = !recieveEmail
            if(recieveEmail == true){
                recieveEmailOut.imageView?.image =  UIImage.init(named: "check")
            }else{
                recieveEmailOut.imageView?.image =  UIImage.init(named: "uncheck")
            }
        default:
            print("nil")
        }
        
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        FBManager.createUsr(emailx: emailTxt!, passcodex: pwdTxt!, fNamex: fNameTxt!, lName: lNameTxt!, gender: genderTxt!)
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
