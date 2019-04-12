//
//  UserViewController.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/11/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    var userArray:[UserAct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserAcctArray()
        
        // Do any additional setup after loading the view.
    }
    

    func getUserAcctArray(){
        FirebaseAPI.shared.getAllUser(completion: {
            allUsrAct, error in
            if(error == nil){
                if let userArray2 = allUsrAct{
                    self.userArray = userArray2
                    print(self.userArray)
                }
                
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            }
        })
            self.userTableView.reloadData()
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
extension UserViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "Cell") as? UserTableViewCell
        let fullN = "\(userArray[indexPath.row].fName) \(userArray[indexPath.row].lName)"
        cell?.fullName.text = fullN
        return cell!
    }
    
    
}
