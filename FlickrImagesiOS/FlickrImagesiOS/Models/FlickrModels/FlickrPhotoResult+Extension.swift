//
//  FlickrPhotoResult+Extension.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

extension FlickrPhotoResultModel {
    
    func getImageURL() -> String {
        return "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
}
