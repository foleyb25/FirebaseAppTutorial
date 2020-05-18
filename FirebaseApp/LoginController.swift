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
    
    let registerButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor.gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let nameView: UITextField = {
        let textView = UITextField()
        textView.placeholder = "Username"
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
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo_no_bg")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        print("Adding gesture recognizer")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectorProfileImageView))
        //let pinchGesture = UIPinchGestureRecognizer(target: target, action: #selector(handleSelectorProfileImageView))
        image.addGestureRecognizer(tapGesture)
        
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
    
    let errorMessageField: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor.red
        tv.backgroundColor = UIColor.clear
        tv.font = UIFont(name: "courier", size: 12)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
        var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent }
        setupTapGesture()
        view.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        view.addSubview(registerSegmentedControl)
        view.addSubview(inputsContainerView)
        inputsContainerView.addSubview(nameView)
        inputsContainerView.addSubview(nameSeperatorView)
        inputsContainerView.addSubview(emailView)
        inputsContainerView.addSubview(emailSeperatorView)
        inputsContainerView.addSubview(passwordView)
        view.addSubview(registerButton)
        view.addSubview(errorMessageField)
        imageView.layer.zPosition = -1
        setupConstraints()
        handleSegmentedControl()
    }
    
    @objc func handleSegmentedControl() {
        let title = registerSegmentedControl.titleForSegment(at: registerSegmentedControl.selectedSegmentIndex)
        registerButton.setTitle(title, for: .normal)
        
        inputsContainerHeightAnchor?.constant = registerSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameHeightAnchor?.isActive = false
        nameHeightAnchor = nameView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: registerSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameHeightAnchor?.isActive = true
        emailHeightAnchor?.isActive = false
        emailHeightAnchor = emailView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: registerSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailHeightAnchor?.isActive = true
        passwordHeightAnchor?.isActive = false
        passwordHeightAnchor = passwordView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: registerSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordHeightAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.33, delay: 0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleLoginRegister() {
        if registerSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailView.text, let password = passwordView.text, !email.isEmpty, !password.isEmpty else {
            errorMessageField.text = "Missing Field"
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.errorMessageField.text = error!.localizedDescription
                print(error!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
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
    
    var inputsContainerHeightAnchor: NSLayoutConstraint?
    var nameHeightAnchor: NSLayoutConstraint?
    var emailHeightAnchor: NSLayoutConstraint?
    var passwordHeightAnchor: NSLayoutConstraint?
    
    func setupConstraints() {
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: registerSegmentedControl.topAnchor, constant: -12).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        registerSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        registerSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        registerSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerHeightAnchor =  inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerHeightAnchor?.isActive = true
        
            //Name Field
        nameView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -4).isActive = true
        nameHeightAnchor = nameView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameHeightAnchor?.isActive = true
        
        nameSeperatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameSeperatorView.centerYAnchor.constraint(equalTo: nameView.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailView.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive = true
        emailView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -4).isActive = true
        emailHeightAnchor = emailView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailHeightAnchor?.isActive = true
        
        emailSeperatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailSeperatorView.centerYAnchor.constraint(equalTo: emailView.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        passwordView.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true
        passwordView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -4).isActive = true
        passwordHeightAnchor = passwordView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordHeightAnchor?.isActive = true
        
        registerButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        registerButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        errorMessageField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        errorMessageField.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 15).isActive = true
        errorMessageField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        errorMessageField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
    }

}

