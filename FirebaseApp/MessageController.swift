//
//  ViewController.swift
//  FirebaseApp
//
//  Created by Brian Foley on 5/13/20.
//  Copyright © 2020 Brian Foley. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handleLogout))
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(handleNewMessage))
       observeMessages()
        
    }
    
    var messageArray = [MessageData]()
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = MessageData(dictionary: dictionary)
                self.messageArray.append(message)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            print(snapshot)
        }, withCancel: nil)
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserIsLoggedIn()
    }

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetNavItem()
        }
    }
    
    func fetchUserAndSetNavItem() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user: user)
            }
            
        }
    }
    
    func setupNavBarWithUser(user: User) {
        /*
        self.navigationItem.title = user.username
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        print("Adding gesture recognizer")
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        containerView.isUserInteractionEnabled = true
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileURL {
            profileImageView.loadImageUsingCacheWithURL(urlString: profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        nameLabel.isUserInteractionEnabled = true
        containerView.addSubview(nameLabel)
        nameLabel.text = user.username
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
       nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        */
        
//        let button = UIButton(type: .system)
//        button.setTitle(user.username, for: .normal)
//        button.addTarget(self, action: #selector(showChatController), for: .touchUpInside)
//        self.navigationItem.titleView = button
//
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellid")
        let message = messageArray[indexPath.row]
        cell.textLabel?.text = message.text
        return cell
    }
    
    @objc func showChatController(user: User) {
        print("Show chat")
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        loginController.MessagesController = self
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
    }
    
}
