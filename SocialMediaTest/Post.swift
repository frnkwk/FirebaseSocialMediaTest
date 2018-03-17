//
//  Post.swift
//  SocialMediaTest
//
//  Created by 若林大悟 on 2018/03/15.
//  Copyright © 2018年 rakko entertainment. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth

struct Post {
    var postID: String
    var userID: String
    var text: String
    var date:Date
}

extension Post {
    public init(text:String) {
        self.init(postID:UUID().uuidString , userID: (Auth.auth().currentUser?.uid)!, text: text, date:Date())
    }
    
    public var documentData: [String: Any] {
        return [
            "postID": postID,
            "userID": userID,
            "text": text,
            "date":date
        ]
    }
}
