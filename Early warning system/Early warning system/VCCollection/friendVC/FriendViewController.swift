//
//  FriendViewController.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/11/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import UIKit
import FirebaseAuth
class FriendViewController: UIViewController {
    @IBOutlet weak var friendTableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseAPI.shared
        let curUsrUid = Auth.auth().currentUser?.uid
        FirebaseAPI.shared.searchForFriendsOf(uid: curUsrUid!,completionHandler: {
            anArrayOfFriends, error in
            if error == nil{
                print(anArrayOfFriends)
                
            }else{
                print(error?.localizedDescription)
            }
        })
    }
    fileprivate func addStudFriends() {
        let dict = ["BuKNySPktENVN89skX67cxW7m4h2":true]
        FirebaseAPI.shared.addAFriend( info: dict)
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
extension FriendViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendTableView.dequeueReusableCell(withIdentifier: "Cell") as? FriendTableViewCell
            cell?.textLabel?.text = "woof"
        
        return cell!
    }
    
    
}
