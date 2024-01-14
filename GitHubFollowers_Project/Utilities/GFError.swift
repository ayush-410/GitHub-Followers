//
//  GFError.swift
//  GitHubFollowers_Project
//
//  Created by Ayush Kumar Singh on 29/11/23.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername  = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse  = "Invalid Response from the server. Please try again later"
    case invalidData      = "The data received from the server is invalid. Please try again later"
    case unableToFavorite = "There is some error while adding this user as Favorites"
    case alreadyInFavorites = "This user is already favorited. You must really like them!!"
}
