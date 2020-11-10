//
//  FlickrViewModel.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import UIKit

class FlickrViewModel: BaseViewModel<UICollectionView> {
    
    var isSearchModeActive: Bool = false
    
    var lastSearches : [String] = []
    
    @objc override func fetchData(completion: ((String?) -> Void)? = nil) {
        FlickrAPIProvider.shared.search(flickrSearch: self.flickrSearch) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let successResult):
                self.setResults(flickrSuccessResult: successResult, completion: completion)
            case .failure(let error):
                self.baseModelDelegation.showAlert(message: error.msg!)
                completion?(nil)
            }            
        }
    }
    
    
    override func setResults(flickrSuccessResult: FlickrResultModel, completion: ((String?) -> Void)? = nil) {
        if self.flickrResult != nil {
            self.flickrResult!.photos.photo += flickrSuccessResult.photos.photo
            self.listView.reloadDataMainThread()
        }else {
            self.flickrResult = flickrSuccessResult
            performSelector(onMainThread: #selector(updateListViewResources), with: nil, waitUntilDone: false)
            self.baseModelDelegation.updateOwnerUI()
        }
            completion?(nil)
    }
    
    @objc func updateListViewResources() {
        self.listView.delegate = self
        self.listView.dataSource = self
        self.listView.reloadDataMainThread()
    }
    
    override func updateSettings(data: Any) {
        
        let settingsModel : FlickrViewModelSettings = data as! FlickrViewModelSettings
        if settingsModel.isSearchModeActive {
            self.lastSearches = AppFlowManager.shared.values(key: .lastSearches) as? [String] ?? []
            self.isSearchModeActive = true
            self.listView.reloadDataMainThread()
        } else {
            self.isSearchModeActive = false
            guard let searchWord = settingsModel.data as? String else {
                  self.listView.reloadData()
                  return
              }
            self.flickrResult = nil
            self.addEntryToSearchHistory(entry: searchWord)
            self.listView.reloadDataMainThread()
            self.flickrSearch = FlickrSearch(search: searchWord, page: 1)
            performSelector(inBackground: #selector(self.fetchData), with: nil)
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
                imageCell.loadImage(url: URL(string: self.flickrResult!.photos.photo[indexPath.row].getImageURL())!)
                return imageCell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard self.flickrResult!.photos.page <= self.flickrResult!.photos.pages || isSearchModeActive else {
            return
        }
        if self.flickrResult!.photos.photo.count > 15 && indexPath.row == (self.flickrResult!.photos.photo.count - 30) {
            self.flickrSearch.page = self.flickrSearch.page + 1
            performSelector(inBackground: #selector(self.fetchData), with: nil)
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
            self.baseModelDelegation.updateOwnerUI()
            performSelector(inBackground: #selector(self.fetchData), with: nil)
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



