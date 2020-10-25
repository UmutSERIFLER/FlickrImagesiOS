//
//  FlickrPhotoResultModel.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

struct FlickrPhotoResultModel: Decodable {
    var id  :   String
    var owner   :  String
    var secret  :   String
    var server  :   String
    var farm    :   Int
    var title   :   String
    var ispublic    :   Int
    var isfriend    :   Int
    var isfamily    :   Int
}
