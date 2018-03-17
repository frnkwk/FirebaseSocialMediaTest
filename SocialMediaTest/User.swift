//
//  User.swift
//  SocialMediaTest
//
//  Created by 若林大悟 on 2018/03/15.
//  Copyright © 2018年 rakko entertainment. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth

struct User {
    
    var userID: String
    
    var name: String
    
    var photoURL: URL
    
    var follow: [String]
}

extension User {
    public init(user: FirebaseAuth.UserInfo) {
        self.init(userID: user.uid,
                  name: user.displayName ?? "",
                  photoURL: user.photoURL ?? URL(string: "https://devimages-cdn.apple.com/assets/elements/icons/xcode/xcode-64x64_2x.png")!,
                  follow: [])
    }
    
    public var documentData: [String: Any] {
        return [
            "userID": userID,
            "name": name,
            "photoURL": photoURL.absoluteString
        ]
    }
}
