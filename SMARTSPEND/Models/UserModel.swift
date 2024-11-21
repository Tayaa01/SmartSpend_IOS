//
//  UserModel.swift
//  SMARTSPEND
//
//  Created by yassmine zammali on 20/11/2024.
//
import Foundation

// Define a model to handle the authenticated user's data
struct UserModel: Decodable {
    let id: String
    let fullName: String
    let email: String
    let token: String // This can be a JWT or any token type you are using
}

