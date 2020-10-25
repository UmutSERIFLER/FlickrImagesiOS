//
//  FlickrViewModelSettings.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

struct FlickrViewModelSettings {
    var data: Any?
    var isSearchModeActive : Bool
    
    init(data: Any? = nil, isSearchModeActive: Bool = false) {
        self.data = data
        self.isSearchModeActive = isSearchModeActive
    }
}
