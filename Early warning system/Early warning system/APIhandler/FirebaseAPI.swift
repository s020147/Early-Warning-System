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
    var ref: DatabaseReference!
    
    func createUsr(emailx: String, passcodex: String, fNamex: String, lName: String, gender:String){
        Auth.auth().createUser(withEmail: emailx, password: passcodex, completion: { result,error in
            if error == nil{
                if let user = result?.user{
                    let dict = ["fName":fNamex,"lName":lName,"Email":user.email,"gender":gender]
                    self.ref.child("User").child(user.uid).setValue(dict)
//                    print("success in creating user : \(user.email!)")
                    
                }
            }else{
                print("error in creating user: \(error)")
            }
            
        })
    }
    
    
    
    
    
}
