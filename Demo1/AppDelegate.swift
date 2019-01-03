///**
/**
Demo1
AppDelegate.swift
Created by: KOMAL BADHE on 31/12/18
Copyright (c) 2019 KOMAL BADHE
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var navigationController = UINavigationController();
    
   
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        
        
        let token = "";
        
        let userDetailsDict = UserHandler().getUserDetails();
        
        UserHandler().updateUserDetails(clientID: userDetailsDict.value(forKey: "client_id") as! String, userName: userDetailsDict.value(forKey: "username") as! String, password: userDetailsDict.value(forKey: "password") as! String, deviceID: token , rememberMe: userDetailsDict.value(forKey: "RememberMe") as! String, name: userDetailsDict.value(forKey: "name") as! String)
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedLogoutNotification), name:.logout , object:nil )
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginBtnNotification(notification:)), name:.login , object:nil )
        
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = STORYBOARD.instantiateViewController(withIdentifier: VCLOADER)
        
        let navigationController = UINavigationController(rootViewController: mainViewController);
        window?.rootViewController = navigationController
        
        
        //customize status bar
        setStatusBarBackgroundColor(color: UIColor.black)
        UIApplication.shared.statusBarStyle = .lightContent
        
        //customize navigation bar
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true;
        
        window?.makeKeyAndVisible()
        
        /*  let defaults: UserDefaults? = UserDefaults.standard
         if defaults?.dictionaryRepresentation().keys.contains("client_id")  == true {
         
         
         }
         else{
         UserHandler().initialize(clientID: "", userName: "", password: "", deviceID: "", rememberMe: "false");
         }*/
        
        
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: getPlistPath())){
            //     print(getPlistPath())
            
            let userDetails : [String: String] = [
                "client_id": "",
                "username": "",
                "password": "",
                "device_id": "",
                "RememberMe":"false",
                "name":""
            ]
            
            let someData = NSDictionary(dictionary: userDetails)
            let isWritten = someData.write(toFile: getPlistPath(), atomically: true)
            print("is the file created: \(isWritten)")
            
            UserHandler().initialize(clientID: "", userName: "", password: "", deviceID: "", rememberMe: "false", name: "");
            
            
        }else{
            
            if let dictRoot = NSDictionary(contentsOfFile: getPlistPath()){
                
                
                //  print(dictRoot);
                
                let clientID = dictRoot.value(forKey: "client_id") as! String
                
                let userName = dictRoot.value(forKey: "username") as! String
                let password = dictRoot.value(forKey: "password") as! String
                let deviceID = dictRoot.value(forKey: "device_id") as! String
                let rememberMe = dictRoot.value(forKey: "RememberMe") as! String
                
                let name = dictRoot.value(forKey: "name") as! String
                UserHandler().initialize(clientID: clientID, userName: userName, password: password, deviceID: deviceID, rememberMe: rememberMe, name: name);
            }
            
        }
        
        
        return true
    }
    
    
    
    @objc func getPlistPath() -> String {
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = (documentDirectory as NSString).appending("/profile.plist")
        
        return path;
    }
    
    @objc func receivedLogoutNotification()  {
        let userDetailsDict = UserHandler().getUserDetails();
        
        if UserHandler().getUserDetails().value(forKey: "RememberMe") as! String == "true" {
            
            UserHandler().updateUserDetails(clientID: userDetailsDict.value(forKey: "client_id") as! String, userName: userDetailsDict.value(forKey: "username") as! String, password: "", deviceID: "", rememberMe: "true", name: userDetailsDict.value(forKey: "name") as! String)
            
        }
        else{
            UserHandler().updateUserDetails(clientID: "", userName: "", password: "", deviceID: "", rememberMe: "false", name: "")
        }
        
        let mainViewController = STORYBOARD.instantiateViewController(withIdentifier: VCLOGIN)
        
        let navigationController = UINavigationController(rootViewController: mainViewController);
        //customize navigation bar
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true;
        
        navigationController.view.makeToast("Sign out successfully.", duration: 1.0, position: CSToastPositionCenter)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // your code here
            self.window?.rootViewController = navigationController;
        }
        
        
        
    }
   
   
    @objc func loginBtnNotification(notification: NSNotification)  {
        
        
        let homeVCObj = STORYBOARD.instantiateViewController(withIdentifier: VCHOME)
        
        
        let drawerViewController = STORYBOARD.instantiateViewController(withIdentifier: VCHOMEDRAWER)
        
        
        let drawerController     = KYDrawerController(drawerDirection: KYDrawerController.DrawerDirection(rawValue: 0)!, drawerWidth: ((window?.frame.size.width)!/4)*3)
        
        
        
        let navigationController = UINavigationController(rootViewController: homeVCObj);
        
        //customize navigation bar
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true;
        
        drawerController.mainViewController = navigationController
        
        drawerController.drawerViewController = drawerViewController
        
        
        
        // homeVCObj.view.makeToast(" Sign in successfully.", duration: 1, position: CSToastPositionBottom);
        window?.rootViewController = drawerController
        
        window?.rootViewController?.navigationController?.view.makeToast(" Sign in successfully.", duration: 2, position: CSToastPositionBottom);
        
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let fileManager = FileManager.default
        var plistPath = getPlistPath()
        
        
        if(!fileManager.fileExists(atPath: getPlistPath())){
            //  print(getPlistPath())
            plistPath = Bundle.main.path(forResource: "manuallyData", ofType: "plist")!
            
        }
        var plistDict = NSMutableDictionary();
        
        plistDict =
            NSMutableDictionary(dictionary: NSDictionary(contentsOfFile: getPlistPath())!);
        let userDetailsDict = UserHandler().getUserDetails();
        
        plistDict.setValue(userDetailsDict.value(forKey: "client_id") as! String, forKey: "client_id")
        plistDict.setValue(userDetailsDict.value(forKey: "username") as! String, forKey: "username")
        plistDict.setValue(userDetailsDict.value(forKey: "password") as! String, forKey: "password")
        plistDict.setValue(userDetailsDict.value(forKey: "device_id") as! String, forKey: "device_id")
        plistDict.setValue(userDetailsDict.value(forKey: "RememberMe") as! String, forKey: "RememberMe")
        plistDict.setValue(userDetailsDict.value(forKey: "name") as! String, forKey: "name")
        plistDict.write(toFile: plistPath, atomically: true)
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
     
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
       
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        
        
        
    }
    
    
}
