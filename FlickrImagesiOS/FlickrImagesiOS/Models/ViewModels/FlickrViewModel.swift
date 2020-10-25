//
//  FlickrViewModel.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import UIKit
import Kingfisher

class FlickrViewModel: BaseViewModel<UICollectionView> {
    
    var isSearchModeActive: Bool = false
    
    var lastSearches : [String] = []
    
    override func fetchData(completion: (() -> Void)? = nil) {
        self.clearCache()
        FlickrAPIProvider.shared.search(flickrSearch: self.flickrSearch) { (result) in
            print(self.flickrSearch.searchString)
            switch result {
            case .success(let successResult):
                self.setResults(flickrSuccessResult: successResult, completion: completion)
                DispatchQueue.main.async {
                    self.baseModelDelegation?.updateOwnerUI()
                }
            case .failure(let error):
                self.baseModelDelegation?.showAlert(message: error.msg!)
                print(error)
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    
    override func setResults(flickrSuccessResult: FlickrResultModel, completion: (() -> Void)? = nil) {
        if self.flickrResult != nil {
            self.flickrResult!.photos.photo += flickrSuccessResult.photos.photo
            DispatchQueue.main.async {
                self.listView?.reloadData()
            }
        }else {
            self.flickrResult = flickrSuccessResult
            DispatchQueue.main.async {
                self.listView!.delegate = self
                self.listView!.dataSource = self
                self.listView?.reloadData()
            }
        }
        DispatchQueue.main.async {
            //self.baseModelDelegation?.updateOwnerUI()
            completion?()
        }
        
    }
    
    override func updateSettings(data: Any? = nil) {
        
        let settingsModel : FlickrViewModelSettings = data as! FlickrViewModelSettings
        if settingsModel.isSearchModeActive {
            self.lastSearches = AppFlowManager.shared.values(key: .lastSearches) as? [String] ?? []
            self.isSearchModeActive = true
            self.listView?.reloadData()
        } else {
            self.isSearchModeActive = false
            guard let searchWord = settingsModel.data as? String else {
                  self.listView?.reloadData()
                  return
              }
            self.flickrResult = nil
            self.addEntryToSearchHistory(entry: searchWord)
            self.listView?.reloadData()
            self.flickrSearch = FlickrSearch(search: searchWord, page: 1)
            self.fetchData()
        }
    }
    
    func addEntryToSearchHistory(entry : String) {
        if var lastSearches = AppFlowManager.shared.values(key: .lastSearches) as? [String] {
            if let index = lastSearches.lastIndex(of: entry) {
                lastSearches.remove(at: index)
                
            }
            lastSearches.insert(entry, at: 0)
            self.lastSearches = lastSearches
            AppFlowManager.shared.saveValue(value: lastSearches, key: .lastSearches)
        } else {
            let lastSearches = [entry]
            self.lastSearches = lastSearches
            AppFlowManager.shared.saveValue(value: lastSearches, key: .lastSearches)
        }
    }
    
    
    func clearCache() {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
    
    
}

extension FlickrViewModel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (isSearchModeActive) ? self.lastSearches.count : self.flickrResult?.photos.photo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.isSearchModeActive {
            if let latestSearchCell : SearchedWordCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchedWordCollectionViewCell.identifier, for: indexPath) as? SearchedWordCollectionViewCell {
                latestSearchCell.searchTextLabel.text = self.lastSearches[indexPath.row]
                return latestSearchCell
            }
        } else {
            if let imageCell : ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell {
                var options : KingfisherOptionsInfo = [.transition(.fade(0.2))]
                options.append(.processor(OverlayImageProcessor(overlay: .black, fraction: 0.5)))
                let imageLink = self.flickrResult!.photos.photo[indexPath.row].getImageURL()
                print(imageLink)
                imageCell.image.kf.setImage(with: URL(string: imageLink)!, options: options)
                return imageCell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if isSearchModeActive {
            return
        }
        
        guard self.flickrResult!.photos.page <= self.flickrResult!.photos.pages else {
            return
        }
        if self.flickrResult!.photos.photo.count > 15 && indexPath.row == (self.flickrResult!.photos.photo.count - 15) {
            self.flickrSearch.page = self.flickrSearch.page + 1
            self.fetchData()
        }
    }
}

extension FlickrViewModel: UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearchModeActive {
            let cell : SearchedWordCollectionViewCell = collectionView.cellForItem(at: indexPath)! as! SearchedWordCollectionViewCell
            self.flickrSearch = FlickrSearch(search: cell.searchTextLabel.text!, page: 1)
            self.isSearchModeActive = false
            self.flickrResult = nil
            DispatchQueue.main.async {
                self.baseModelDelegation?.updateOwnerUI()
            }
            self.fetchData()
        }
    }
    
}


extension FlickrViewModel: UICollectionViewDelegateFlowLayout {
    
    func cellHeightForCellsInRow(at indexPath: IndexPath, cellsPerRow: Int) -> CGFloat {
        return 80
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let widthForAllCells = collectionView.frame.width - self.insets.left - self.insets.right - collectionView.contentInset.left - collectionView.contentInset.right - ((CGFloat(self.numberOfCellsForCurrentDevice) - 1) * self.minimumInterItemSpacing)
//
//        let cellWidth = widthForAllCells / CGFloat(self.numberOfCellsForCurrentDevice)
//        let cellHeight : CGFloat = cellHeightForCellsInRow(at: indexPath, cellsPerRow: self.numberOfCellsForCurrentDevice)
//
        if isSearchModeActive {
            return CGSize(width: collectionView.frame.width, height: 40)
        }
        let cellWidth = (collectionView.frame.width - 30 ) / 2
        return CGSize(width: cellWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}



