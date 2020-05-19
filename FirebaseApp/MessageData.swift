//
//  MessageData.swift
//  FirebaseApp
//
//  Created by Brian Foley on 5/19/20.
//  Copyright © 2020 Brian Foley. All rights reserved.
//

import UIKit

class MessageData: NSObject {
    var text: String?
    var toId: String?
    var timestamp: NSNumber?
    var fromId: String?
    
    init(dictionary: [String: AnyObject]) {
        text = dictionary["text"] as? String
        toId = dictionary["toid"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        fromId = dictionary["fromid"] as? String
    }
}


