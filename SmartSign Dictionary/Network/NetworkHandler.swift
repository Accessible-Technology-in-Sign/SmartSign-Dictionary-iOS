//
//  NetworkHandler.swift
//  SmartSign Dictionary
//
//  Created by Srivinayak Chaitanya Eshwa on 21/08/24.
//

import Foundation

final class NetworkHandler {
    func getVideos(for queryString: String) async throws -> Data {
        
        let queryItems = [
            URLQueryItem(name: "part", value: "snippet"),
            URLQueryItem(name: "q", value: queryString),
            URLQueryItem(name: "channelId", value: NetworkConstants.channelId),
            URLQueryItem(name: "key", value: NetworkConstants.apiKey)
        ]
        
        var urlComponents = URLComponents(string: NetworkConstants.baseUrl)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            throw NetworkError.malformedURL
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        // TODO: Check for status code
        
        return data
    }
}
