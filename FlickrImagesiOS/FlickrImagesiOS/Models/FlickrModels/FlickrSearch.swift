//
//  FlickrSearch.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

struct FlickrSearch {
    
    var searchString : String
    var page : Int
    
    init(search:String = "", page: Int = 1) {
        self.searchString = search
        self.page = page
    }
    
}
