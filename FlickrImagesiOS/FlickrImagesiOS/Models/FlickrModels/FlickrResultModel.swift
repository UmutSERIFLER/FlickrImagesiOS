//
//  FlickrResultModel.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import Foundation

struct FlickrResultModel: Decodable {
    var photos  : FlickrPhotosResultModel
    var stat    :   String
}
