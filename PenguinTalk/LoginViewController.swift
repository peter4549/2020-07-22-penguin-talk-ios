//
//  LoginViewController.swift
//  PenguinTalk
//
//  Created by 김성주 on 2020/07/16.
//  Copyright © 2020 김성주. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test...
        try! Auth.auth().signOut()
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        color = remoteConfig["splash_background"].stringValue
        color = String(color?.suffix(6) ?? "000000")
        
        statusBar.backgroundColor = UIColor(rgb: Int(color!, radix: 16) ?? 0)
        buttonLogin.backgroundColor = UIColor(rgb: Int(color!, radix: 16) ?? 0)
        buttonSignUp.backgroundColor = UIColor(rgb: Int(color!, radix: 16) ?? 0)
        
        buttonLogin.addTarget(self, action: #selector(signInEvent), for: .touchUpInside)
        buttonSignUp.addTarget(self, action: #selector(presentSignUpView), for: .touchUpInside)
        
        Auth.auth().addStateDidChangeListener { (auth, user)
            in
            if (user != nil) {
                let view = self.storyboard?.instantiateViewController(withIdentifier: "MainViewTabBarController") as! UITabBarController
                self.present(view, animated: true, completion: nil)
            }
        }
    }
    
    @objc func presentSignUpView() {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        self.present(view, animated: true, completion: nil)
    }
    
    @objc func signInEvent() {
        Auth.auth().signIn(withEmail: textFieldEmail.text!, password: textFieldPassword.text!) { (authDataResult, error) in
            if (error != nil) {
                let alert = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
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
