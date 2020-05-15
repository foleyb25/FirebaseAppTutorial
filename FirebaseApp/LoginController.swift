//
//  LoginController.swift
//  FirebaseApp
//
//  Created by Brian Foley on 5/13/20.
//  Copyright © 2020 Brian Foley. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginController: UIViewController {

    var ref: DatabaseReference!
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let inputsContainerViewLogin: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let registerButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor.gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let nameView: UITextField = {
        let textView = UITextField()
        textView.placeholder = "Name"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let nameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailView: UITextField = {
        let textView = UITextField()
        textView.placeholder = "Email"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordView: UITextField = {
        let textView = UITextField()
        textView.placeholder = "Password"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isSecureTextEntry = true
        return textView
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo_no_bg")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let registerSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentedControl), for: .valueChanged)
        return sc
    }()
    
    @objc func handleSegmentedControl() {
        let title = registerSegmentedControl.titleForSegment(at: registerSegmentedControl.selectedSegmentIndex)
        registerButton.setTitle(title, for: .normal)
        print(registerSegmentedControl.selectedSegmentIndex)
        if registerSegmentedControl.selectedSegmentIndex == 0 {
            inputsContainerView.removeFromSuperview()
            view.addSubview(inputsContainerViewLogin)
            inputsContainerViewLogin.addSubview(emailView)
            inputsContainerViewLogin.addSubview(emailSeperatorView)
            inputsContainerViewLogin.addSubview(passwordView)
            setupConstraintsLogin()
            UIView.animate(withDuration: 0.33, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            self.inputsContainerViewLogin.removeFromSuperview()
           inputsContainerView.addSubview(nameView)
           inputsContainerView.addSubview(nameSeperatorView)
           inputsContainerView.addSubview(emailView)
           inputsContainerView.addSubview(emailSeperatorView)
           inputsContainerView.addSubview(passwordView)
           view.addSubview(inputsContainerView)
           self.setupConstraints()
            UIView.animate(withDuration: 0.33, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func handleRegister() {
        guard let email = emailView.text, let password = passwordView.text, let name = nameView.text else {
            print("Fields not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                
                print(error!)
                return
            }
     
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            self.ref = Database.database().reference()
            let usersReference = self.ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values) { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                
                print("Saved user into firebase DB")
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
        var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent }
        setupTapGesture()
        view.addSubview(imageView)
        view.addSubview(registerSegmentedControl)
        view.addSubview(inputsContainerViewLogin)
        inputsContainerViewLogin.addSubview(emailView)
        inputsContainerViewLogin.addSubview(emailSeperatorView)
        inputsContainerViewLogin.addSubview(passwordView)
        view.addSubview(registerButton)
        setupConstraintsLogin()
    }
    
    func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        emailView.resignFirstResponder()
        passwordView.resignFirstResponder()
        nameView.resignFirstResponder()
    }
    
    func setupConstraints() {
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: registerSegmentedControl.topAnchor, constant: -12).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        registerSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        registerSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        registerSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
            //Name Field
        nameView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        nameView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -4).isActive = true
        
        nameSeperatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameSeperatorView.centerYAnchor.constraint(equalTo: nameView.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailView.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive = true
        emailView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        emailView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -4).isActive = true
        
        emailSeperatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailSeperatorView.centerYAnchor.constraint(equalTo: emailView.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        passwordView.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true
        passwordView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        passwordView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -4).isActive = true
        
        registerButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        registerButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupConstraintsLogin() {
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: registerSegmentedControl.topAnchor, constant: -12).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        registerSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerViewLogin.topAnchor, constant: -12).isActive = true
        registerSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerViewLogin.widthAnchor).isActive = true
        registerSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputsContainerViewLogin.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        inputsContainerViewLogin.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerViewLogin.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewLogin.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        emailView.centerXAnchor.constraint(equalTo: inputsContainerViewLogin.centerXAnchor).isActive = true
        emailView.topAnchor.constraint(equalTo: inputsContainerViewLogin.topAnchor).isActive = true
        emailView.heightAnchor.constraint(equalTo: inputsContainerViewLogin.heightAnchor, multiplier: 1/2).isActive = true
        emailView.widthAnchor.constraint(equalTo: inputsContainerViewLogin.widthAnchor, constant: -4).isActive = true
        
        emailSeperatorView.centerXAnchor.constraint(equalTo: inputsContainerViewLogin.centerXAnchor).isActive = true
        emailSeperatorView.centerYAnchor.constraint(equalTo: emailView.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputsContainerViewLogin.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordView.centerXAnchor.constraint(equalTo: inputsContainerViewLogin.centerXAnchor).isActive = true
        passwordView.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true
        passwordView.heightAnchor.constraint(equalTo: inputsContainerViewLogin.heightAnchor, multiplier: 1/2).isActive = true
        passwordView.widthAnchor.constraint(equalTo: inputsContainerViewLogin.widthAnchor, constant: -4).isActive = true
        
        registerButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputsContainerViewLogin.bottomAnchor, constant: 12).isActive = true
        registerButton.widthAnchor.constraint(equalTo: inputsContainerViewLogin.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
