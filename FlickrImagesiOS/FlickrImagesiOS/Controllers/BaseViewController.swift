//
//  BaseViewController.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import UIKit
import Kingfisher

class BaseViewController<T>: UIViewController, BaseViewModelProtocol {
    
    
    var viewModel : BaseViewModel<T>!
    
    var activityIndicator : UIActivityIndicatorView?
    
    // MARK: View Life Cycle Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopActivityIndicator()
    }
    
    func stopActivityIndicator() {
        if self.activityIndicator?.isAnimating ?? false {
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                self.activityIndicator?.removeFromSuperview()
                self.activityIndicator = nil
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
    
    
    // MARK: BaseDelegation
    
    func updateOwnerUI() {
        
    }
    
    func showAlert(message:String) {
        
    }
    
    
}
