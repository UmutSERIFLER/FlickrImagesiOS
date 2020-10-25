//
//  FlickrPhotosResultModel.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import Foundation

struct FlickrPhotosResultModel: Decodable {
    var page :  Int
    var pages   :   Int
    var perpage :   Int
    var total   :   String?
    var photo: [FlickrPhotoResultModel]
}
