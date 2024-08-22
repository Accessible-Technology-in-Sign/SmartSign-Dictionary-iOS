//
//  NetworkError.swift
//  SmartSign Dictionary
//
//  Created by Srivinayak Chaitanya Eshwa on 21/08/24.
//

import Foundation

enum NetworkError: ProjectError {
    case malformedURL
    case otherErrors(statusCode: Int)
    
    var title: String {
        switch self {
        case .malformedURL:
            return String(localized: "Network Error")
        case .otherErrors:
            return String(localized: "Network Error")
        }
    }
    
    var message: String {
        switch self {
        case .malformedURL:
            return String(localized: "There seems to be an error with the YouTube URL. Please contact the developers to resolve the issue")
        case .otherErrors(let statusCode):
            return HTTPURLResponse.localizedString(forStatusCode: statusCode)
        }
    }
}
