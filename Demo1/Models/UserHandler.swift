///**
/**
 Demo1
 ViewController.swift
 Created by: KOMAL BADHE on 31/12/18
 Copyright (c) 2019 KOMAL BADHE
 */
import Foundation
class UserHandler: NSObject {
    var userDetailsDict = NSMutableDictionary();
    
    //Mark : initialization
    func initialize(clientID:String,userName : String, password : String, deviceID :String,rememberMe : String,name :String)  {
        self.userDetailsDict = ["client_id":clientID,"username":userName,"password":password,"device_id":deviceID,"RememberMe":rememberMe,"name":name];
        self.saveUserDetails();
    }
    //Mark : update user details
    func updateUserDetails(clientID: String,userName : String,password : String , deviceID : String , rememberMe : String , name :String)  {
        self.userDetailsDict.setValue(name, forKey: "name")
        self.userDetailsDict.setValue(clientID, forKey: "client_id")
        self.userDetailsDict.setValue(userName, forKey: "username")
        self.userDetailsDict.setValue(password, forKey: "password")
        self.userDetailsDict.setValue(deviceID, forKey: "device_id")
        self.userDetailsDict.setValue(rememberMe, forKey: "RememberMe")
        self.saveUserDetails();
    }
    //Mark: Fetch user details
    @objc func getUserDetails() -> NSDictionary{
        let details : NSDictionary =  NSDictionary(dictionary: UserDefaults.standard.object(forKey: "UserDetails") as! NSMutableDictionary);
        let userDetails : NSDictionary = NSDictionary(dictionary: details);
        return userDetails;
    }
    //Mark: Save user details
    func saveUserDetails()  {
        UserDefaults.standard.set(self.userDetailsDict , forKey: "UserDetails");
        UserDefaults.standard.synchronize();
    }
    
    
    //MARK: User Authentication
    
    func authenticate_user(clientID: String,userName : String,password : String ) -> NSDictionary {
        var responsDict = NSDictionary();
        if clientID == "komal" {
            if userName == "komal" && password == "komal"{
                responsDict = ["status" :  "true"];
            }
            else{
                responsDict = ["status" :  "iu"];
            }
        }
        else{
            responsDict = ["status" :  "ic"];
        }
        return responsDict;
        
    }
    
}
