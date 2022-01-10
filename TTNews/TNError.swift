//
//  TNError.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/5/22.
//

import Foundation

enum TNError: String, Error {
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unknownError = "An unknown error just happened."
}
