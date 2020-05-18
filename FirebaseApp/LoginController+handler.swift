//
//  LoginController+handler.swift
//  FirebaseApp
//
//  Created by Brian Foley on 5/15/20.
//  Copyright © 2020 Brian Foley. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleRegister() {
        guard let email = emailView.text, let password = passwordView.text, let name = nameView.text, !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            errorMessageField.text = "Missing Field"
            return
        }
        
        print(email)
        print(password)
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.errorMessageField.text = error?.localizedDescription
                print(error!)
                return
            }
     
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profilePictures").child(imageName)
            if let uploadData = self.imageView.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    
                    storageRef.downloadURL { (url, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        print(url!.absoluteString)
                    
                        let values = ["username": name, "email": email, "profileImage": url!.absoluteString] as [String : Any]
                       
                        self.registerUserImageDB(uid: uid, values: values)
                        
                    }
                    
                }
            }
            
        })
        
    }
    
    private func registerUserImageDB(uid: String, values: [String: Any]) {
        self.ref = Database.database().reference()
           let usersReference = self.ref.child("users").child(uid)
           usersReference.updateChildValues(values) { (err, ref) in
               if err != nil {
                   print(err!)
                   return
               }
               
               self.dismiss(animated: true, completion: nil)
           }
    }
    
    @objc func handleSelectorProfileImageView() {
        let picker = UIImagePickerController()
        picker.modalPresentationStyle = .fullScreen
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] {
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
