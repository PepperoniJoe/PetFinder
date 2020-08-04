//
//  Constants.swift
//  PetFinder
//
//  Created by Marcy Vernon on 8/3/20.
//

import Foundation

struct K {
    
    static let bodyString   = "grant_type=client_credentials&client_id=" + Credential.clientID + "&client_secret=" + Credential.clientSecret
    
    static let urlString: (token: String, request: String) = (
        "https://api.petfinder.com/v2/oauth2/token",
        "https://api.petfinder.com/v2/types/dog/breeds"
    )
}

struct Error {
    static let invalidURL  = "Invalid URL"
    static let invalidBody = "Invalid body"
    static let noData      = "No data"
    static let noToken     = "🚧 No token received. Verify credentials in API-Keys.swift."
}

struct Warning {
    static let testDataUsed = "🚧 Caution. This app is using TEST data."
}
