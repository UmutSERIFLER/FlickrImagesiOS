//
//  BaseViewModel.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import UIKit

class BaseViewModel<T>: NSObject {
    
    var listView: T?
    
    var flickrResult: FlickrResultModel?
    
    var baseModelDelegation: BaseViewModelProtocol?
    
    var insets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    var minimumInterItemSpacing  : CGFloat = 8.0
    var minimumLineSpacing : CGFloat = 8.0
    
    
    lazy var flickrSearch : FlickrSearch = {
        return FlickrSearch()
    }()
    
    
    init(listView: T? = nil, modelDelegation: BaseViewModelProtocol? = nil) {
        self.listView = listView
        self.baseModelDelegation = modelDelegation
        super.init()
    }
    
    func fetchData(completion : (()-> Void)? = nil) {
        
    }
    
    func setResults(flickrSuccessResult: FlickrResultModel, completion : (()-> Void)? = nil){
        
    }
    
    func updateSettings(data: Any? = nil) {
        
    }
    
    
    
}
