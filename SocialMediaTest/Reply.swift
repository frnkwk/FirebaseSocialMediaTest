//
//  Reply.swift
//  SocialMediaTest
//
//  Created by 若林大悟 on 2018/03/17.
//  Copyright © 2018年 rakko entertainment. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth

struct Reply {
    var replyID: String
    var postID: String
    var userID: String
    var text: String
    var date:Date
}

extension Reply {
    public init(postID:String, text:String) {
        self.init(replyID:UUID().uuidString, postID:postID, userID: (Auth.auth().currentUser?.uid)!, text: text, date:Date())
    }
    
    public var documentData: [String: Any] {
        return [
            "replyID": replyID,
            "postID": postID,
            "userID": userID,
            "text": text,
            "date":date
        ]
    }
}
