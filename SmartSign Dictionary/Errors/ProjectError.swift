//
//  ProjectError.swift
//  SmartSign Dictionary
//
//  Created by Srivinayak Chaitanya Eshwa on 21/08/24.
//

import Foundation

protocol ProjectError: Error {
    var title: String { get }
    var message: String { get }
}
