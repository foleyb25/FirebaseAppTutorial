//
//  ChatLogController.swift
//  FirebaseApp
//
//  Created by Brian Foley on 5/18/20.
//  Copyright © 2020 Brian Foley. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.username
        }
    }
    
    let bottomContainerView: UIView = {
       let bcv = UIView()
        bcv.translatesAutoresizingMaskIntoConstraints = false
        bcv.backgroundColor = UIColor.lightGray
        bcv.layer.cornerRadius = 20
        bcv.layer.masksToBounds = true
        return bcv
    }()
    
    let sendButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Send", for: .normal)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.setTitleColor(UIColor.blue, for: .normal)
        sb.addTarget(self, action: #selector(handleSendPush), for: .touchUpInside)
        //sb.backgroundColor = UIColor.white
        return sb
    }()
    
    lazy var inputTextField: UITextField = {
       let itv = UITextField()
        itv.placeholder = "Enter Message..."
        itv.translatesAutoresizingMaskIntoConstraints = false
        itv.delegate = self
        return itv
    }()
    
    let typeSeperatorLine: UIView = {
       let tsl = UIView()
        tsl.translatesAutoresizingMaskIntoConstraints = false
        tsl.backgroundColor = UIColor.gray
        return tsl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        view.addSubview(bottomContainerView)
        //view.addSubview(typeSeperatorLine)
        bottomContainerView.addSubview(sendButton)
        bottomContainerView.addSubview(inputTextField)
        setupConstraints()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotificationShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotificationHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    var bottomContainerAnchor: NSLayoutConstraint?
    
    func setupConstraints() {
        
        bottomContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        bottomContainerAnchor = bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomContainerAnchor!.isActive = true
        bottomContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        bottomContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
       
        
        sendButton.rightAnchor.constraint(equalTo: bottomContainerView.rightAnchor, constant: -10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: bottomContainerView.heightAnchor, constant: -10).isActive = true
        
        inputTextField.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: bottomContainerView.leftAnchor, constant: 8).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: bottomContainerView.heightAnchor).isActive = true
        
        /*
        typeSeperatorLine.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
       typeSeperatorLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
       typeSeperatorLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        typeSeperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        */
    }
    
    @objc func handleSendPush() {
        guard let inputText = inputTextField.text, !inputText.isEmpty else {
            return
        }
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.userId!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = NSNumber( value: NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toid": toId, "fromid": fromId, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values as [AnyHashable : Any])
        UIView.animate(withDuration: 0.5, animations: {
            self.inputTextField.frame.origin.x += 500
        }) { (bool) in
            print("Completion")
            self.inputTextField.frame.origin.x -= 500
        }
        
        inputTextField.text = ""
    }
    
    @objc func dismissKeyboard() {
        inputTextField.resignFirstResponder()
    }
   
    @objc func keyboardNotificationHide(notification: NSNotification) {
        print("Hide Keyboard")
      
        bottomContainerAnchor!.isActive = false
        bottomContainerAnchor = bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomContainerAnchor!.isActive = true
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
                   self.view.layoutIfNeeded()
               }, completion: nil)
    }
    
    @objc func keyboardNotificationShow(notification: NSNotification) {
        print("Show Keyboard")
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        print(keyboardSize!.height)
        bottomContainerAnchor!.isActive = false
        bottomContainerAnchor = bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -(keyboardSize!.height))
        bottomContainerAnchor!.isActive = true
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendPush()
        return true
    }
}
