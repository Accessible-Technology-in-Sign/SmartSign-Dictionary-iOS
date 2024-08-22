//
//  NetworkError.swift
//  SmartSign Dictionary
//
//  Created by Srivinayak Chaitanya Eshwa on 21/08/24.
//

import Foundation

enum NetworkError: ProjectError {
    case malformedURL
    
    var title: String {
        switch self {
        case .malformedURL:
            return String(localized: "Network Error")
        }
    }
    
    var message: String {
        switch self {
        case .malformedURL:
            return String(localized: "There seems to be an error with the YouTube URL. Please contact the developers to resolve the issue")
        }
    }
}
