//
//  FlickrServices.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import Foundation

class FlickrServices  {
    
    
    private static let flickrBaseURL =  KeyProvider.flickrURL
    private static let flickrAPIKey = KeyProvider.flickrApiKey
    // Service Titles
    
    private static let restServiceTitle = "services/rest/"
    
    private static let searchService = "flickr.photos.search"
    
    //e5960c65494d0f50bd8b0cefd7d092fa    kittens
    
    /// Services
    
    static func searchService(word: String = "", page: Int = 1) -> String {
        return flickrBaseURL + restServiceTitle + "?method=" + searchService + "&api_key=\(flickrAPIKey)" + "&format=json&nojsoncallback=1&text=" + word + "&page=\(page)&per_page=50&dimension_search_mode=min&height=1024&width=1024"
    }
    
}
