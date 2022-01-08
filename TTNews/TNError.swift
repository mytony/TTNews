//
//  TNError.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/5/22.
//

import Foundation

enum TNError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. You must REALLY like them!"
    case unknownError = "An unknown error just happened."
}
