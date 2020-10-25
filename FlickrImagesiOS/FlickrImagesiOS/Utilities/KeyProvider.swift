//
//  KeyProvider.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import Foundation

class KeyProvider{
    
    static private(set) var flickrURL : String = ""
    static private(set) var flickrApiKey : String = ""
    
    static func readValues() {
        
        if let url = Bundle.main.url(forResource: "Keys", withExtension: "json") {
            do {
                let keysData = try JSONDecoder().decode(KeysModel.self, from: Data(contentsOf: url))
                flickrURL = keysData.Keys.FlickrURL
                flickrApiKey = keysData.Keys.FlickrApiKey
            } catch {
                // handle error
            }
        }
    }
}
