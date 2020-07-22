//
//  SignUpViewController.swift
//  PenguinTalk
//
//  Created by 김성주 on 2020/07/21.
//  Copyright © 2020 김성주. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        color = remoteConfig["splash_background"].stringValue
        color = String(color?.suffix(6) ?? "000000")
        
        statusBar.backgroundColor = UIColor(rgb: Int(color!, radix: 16) ?? 0)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImagePicker)))
        
        buttonSignUp.backgroundColor = UIColor(rgb: Int(color!, radix: 16) ?? 0)
        buttonCancel.backgroundColor = UIColor(rgb: Int(color!, radix: 16) ?? 0)
        
        buttonSignUp.addTarget(self, action: #selector(runSignUpEvent), for: .touchUpInside)
        buttonCancel.addTarget(self, action: #selector(runCancelEvent), for: .touchUpInside)
    
    }
    
    @objc func runSignUpEvent() {
        Auth.auth().createUser(withEmail: textFieldEmail.text!, password: textFieldPassword.text!) { authResult, error in
            let uid = authResult?.user.uid
            let image = self.imageView.image!.jpegData(compressionQuality: 0.5)
            let storageReference = Storage.storage().reference().child("userImages").child(uid!)
        
            storageReference.putData(image!, metadata: nil, completion: {
                data, error in
                storageReference.downloadURL { (url, error) in
                    let imageUrl = url?.absoluteString
                    
                    Database.database().reference().child("users").child(uid!).setValue(["name": self.textFieldName.text!, "profileImageUrl": imageUrl], withCompletionBlock: {
                        error, reference in
                        
                    })
                }
                
            })
        }
    }
    
    @objc func runCancelEvent() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
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
