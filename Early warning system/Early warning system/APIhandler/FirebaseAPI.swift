//
//  FirebaseAPI.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/10/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FirebaseAPI:NSObject{
    static let shared = FirebaseAPI()
    private override init() {}
    var ref: DatabaseReference = Database.database().reference()
    
    func createUsr(emailx: String, passcodex: String, fNamex: String, lName: String, gender:String){
        Auth.auth().createUser(withEmail: emailx, password: passcodex, completion: { result,error in
            if error == nil{
                if let user = result?.user{
                    //you might not be able to access due to login
                    let dict = ["fName":fNamex,"lName":lName,"Email":emailx,"gender":gender]
                    print(self.ref.child("User").child(user.uid))
                    self.ref.child("User").child(user.uid).setValue(dict)
                    print("Success in creating: \(fNamex)")
                }
            }else{
                print("error in creating user: \(error)")
            }
        })
    }
    
    
    //at the end of class note, the user is not right, log out and login to  a better account
    
    func searchForFriendsOf(uid:String, completionHandler: @escaping(_ allFriends:[String]?,_ error:Error?)->Void){
        print(Auth.auth().currentUser!.uid)
        self.ref.child("User").child(Auth.auth().currentUser!.uid).child("Friend").observe(.value, with: {
            snapshot in
            print(snapshot)
            if let snap = snapshot.value as? [String:Any]{
                var friendUid:[String] = []
                for record in snap{
                    let uid: String = (record.key as? String)!
                    friendUid.append(uid)
                }
                print(friendUid)
            completionHandler(friendUid,nil)
            }else{
                print("zero friends found")
            }
        })
        
    }
    func getAllUser(completion: @escaping(_ allUsersAct:[UserAct]?,_ error:Error?)->Void){
        self.ref.child("User").observeSingleEvent(of: .value, with: {
            snapshot in
            if let snap = snapshot.value as?[String:Any]{
                
                var allUsersAct:[UserAct] = []
                for record in snap{
                    let userInfo:[String:Any] = (record.value as? [String:Any])!
                    
                    var friendsArray:[String] = [""]
                    /* add friends
                     for everyFrd in userInfo[]
                     */
                    
                    let email:String = userInfo["Email"] as! String
                    let fName:String = (userInfo["fName"] as? String)!
                    let lName:String = userInfo["lName"] as! String
                    let gend:String = userInfo["gender"] as! String
                    let oneUsr: UserAct = UserAct(email: email, fName: fName, lName: lName, gender: gend, friends: friendsArray)
                    
                    allUsersAct.append(oneUsr)
                    print(allUsersAct.count)
                }
                completion(allUsersAct,nil)
            }else{
                print("db is empty")
                }
        })
    }
    func childUpdate(info:[String:Any]){
        print(Auth.auth().currentUser?.uid)
        self.ref.child("User").child(Auth.auth().currentUser!.uid).updateChildValues(info)
    }
    
    func addAFriend(info:[String:Any]){
        self.ref.child("User").child(Auth.auth().currentUser!.uid).child("Friend").updateChildValues(info)
    }
    
    

    func loginToAct(userEmail: String, password: String){
        Auth.auth().signIn(withEmail: userEmail, password: password, completion: {(result, error) in
            if error == nil{
                if let user = result?.user{
                    print("sign in success user: \(user.uid)")
                }else{
                    print("no user, FAIL")
                }
                
            }else{
                print(error?.localizedDescription)
            }
            
        })
    }
//    @IBAction func loginAction(_ sender: UIButton) {
//        userText = userTextField.text!
//        passwordText = passwordTextField.text!
//        Auth.auth().signIn(withEmail: userText, password: passwordText, completion: { (result,error) in
//            if error == nil{
//                if let user = result?.user{
//                    print("sign in success")
//                    self.accessValid = true
//                }
//            }else{
//                print(error?.localizedDescription)
//            }
//
//        })
//    }
    
    
    
    
    
    
}
