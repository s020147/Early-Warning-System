//
//  SettingViewController.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/11/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import UIKit
import FirebaseAuth
class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signoutAction(_ sender: UIButton) {
        try! Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
        
        
    }
    @IBAction func editUser(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "EditUserViewController") as? EditUserViewController{
            navigationController?.pushViewController(controller, animated: true)
        }
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
