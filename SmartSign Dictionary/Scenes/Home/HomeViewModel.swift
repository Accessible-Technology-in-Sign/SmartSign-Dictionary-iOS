//
//  HomeViewModel.swift
//  SmartSign Dictionary
//
//  Created by Srivinayak Chaitanya Eshwa on 21/08/24.
//

import Foundation

final class HomeViewModel {
    
    private let networkHandler: NetworkHandler
    
    init(networkHandler: NetworkHandler = NetworkHandler()) {
        self.networkHandler = networkHandler
    }
    
    func getVideoData(for queryString: String) async throws -> [Video] {
        let data = try await networkHandler.getVideos(for: queryString)
        
        guard let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let items = jsonData["items"] as? [[String: Any]] else {
            return []
        }
        
        let videos: [Video] = items.compactMap { item in
            guard let snippet = item["snippet"] as? [String: Any],
                  let id = item["id"] as? [String: Any],
                  let videoId = id["videoId"] as? String,
                  let title = snippet["title"] as? String,
                  let thumbnails = snippet["thumbnails"] as? [String: Any],
                  let mediumThumbnail = thumbnails["medium"] as? [String: Any],
                  let thumbnailURL = mediumThumbnail["url"] as? String
            else { return nil }
            
            return Video(title: title, thumbnailURL: thumbnailURL, videoId: videoId)
            
        }
        
        return videos
        
    }
    
}
