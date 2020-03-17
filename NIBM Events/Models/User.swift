//
//  File.swift
//  Ravinsu M.H.S - COBSCComp171P-001
//
//  Created by Sahan Ravindu on 5/22/19.
//  Copyright © 2019 Sahan Ravindu. All rights reserved.
//

import Foundation

class User{
    
    //let id: Int!
    let uName: String!
    let uPhone: String!
    let uProfImgUrl: String!
    let uEmail: String!
    let uPassword: String!
    
    init(uName: String, uPhone: String!, uProfImgUrl: String, uEmail: String, uPassword: String){
        
        // self.id = id
        self.uName = uName
        self.uPhone = uPhone
        self.uProfImgUrl = uProfImgUrl
        self.uEmail = uEmail
        self.uPassword = uPassword
        
    }
    
    init(uName: String, uPhone: String!, uProfImgUrl: String){
        
        // self.id = id
        self.uName = uName
        self.uPhone = uPhone
        self.uProfImgUrl = uProfImgUrl
        self.uEmail = ""
        self.uPassword = ""
        
    }
}
