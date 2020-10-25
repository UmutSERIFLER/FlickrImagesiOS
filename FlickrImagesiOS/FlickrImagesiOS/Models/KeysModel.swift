//
//  KeysModel.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

struct KeysModel: Decodable {
    
    let Keys : Keys
    
    struct Keys : Decodable {
        var FlickrURL       :   String
        var FlickrApiKey    :   String
    }
    

}
