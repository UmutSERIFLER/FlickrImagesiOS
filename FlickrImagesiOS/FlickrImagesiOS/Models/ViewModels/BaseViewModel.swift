//
//  BaseViewModel.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import UIKit

class BaseViewModel<T>: NSObject {
    
    var listView: T!
    
    var flickrResult: FlickrResultModel!
    
    var baseModelDelegation: BaseViewModelProtocol!
    
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
    
    func fetchData(completion : ((String?)-> Void)? = nil) {
        
    }
    
    func setResults(flickrSuccessResult: FlickrResultModel, completion : ((String?)-> Void)? = nil){
        
    }
    
    func updateSettings(data: Any) {
        
    }
}

extension BaseViewModel where T: UITableView {
    func renewOwnerShip(){
        DispatchQueue.main.async {
            self.listView.delegate = (self as! UITableViewDelegate)
            self.listView.dataSource = (self as! UITableViewDataSource)
            self.listView.reloadData()
        }
    }
}

extension BaseViewModel where T: UICollectionView {
    func renewOwnerShip(){
        DispatchQueue.main.async {
            self.listView.delegate = (self as! UICollectionViewDelegate)
            self.listView.dataSource = (self as! UICollectionViewDataSource)
            self.listView.reloadData()
        }
    }
}

extension UICollectionView {
    func reloadDataMainThread() {
        self.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
    }
    
}
