//
//  FlickrViewController.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import UIKit

class FlickrViewController: BaseViewController<UICollectionView> {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var imagesCollectionView: UICollectionView!{
        didSet {
            imagesCollectionView.register(ImageCollectionViewCell.nib, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
            imagesCollectionView.register(SearchedWordCollectionViewCell.nib, forCellWithReuseIdentifier: SearchedWordCollectionViewCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.accessibilityLabel = "imageSearchBar"
        self.imagesCollectionView.accessibilityLabel = "imagesCollectionView"
        let layout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        self.viewModel = FlickrViewModel(listView: self.imagesCollectionView, modelDelegation: self)
        self.activityIndicator = self.view.startActivityIndicator()
        self.viewModel?.fetchData(completion: {
            self.stopActivityIndicator()
        })
    }
    
    
    override func updateOwnerUI() {
        super.updateOwnerUI()
        self.stopActivityIndicator()
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    
    override func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                self.searchBar.text = ""
                self.searchBar.resignFirstResponder()
                self.viewModel?.updateSettings(data: FlickrViewModelSettings(data: nil, isSearchModeActive: false))
              case .cancel, .destructive:
                    print("cancel/destructive")
        }}))
        self.present(alert, animated: true, completion: nil)
    }

    
}

extension FlickrViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            // Text is empty, show suggested searches again.
            self.viewModel?.updateSettings(data: FlickrViewModelSettings(data: nil, isSearchModeActive: false))
        } else {
            self.viewModel?.updateSettings(data: FlickrViewModelSettings(data: nil, isSearchModeActive: true))
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.viewModel?.updateSettings(data: FlickrViewModelSettings(data: nil, isSearchModeActive: true))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text, !searchWord.isEmpty, !searchWord.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.searchBar.resignFirstResponder()
            self.viewModel?.updateSettings(data: FlickrViewModelSettings(data: nil, isSearchModeActive: false))
            return
        }
        
        self.activityIndicator = self.view.startActivityIndicator()
        self.viewModel?.updateSettings(data: FlickrViewModelSettings(data: String(searchWord), isSearchModeActive: false))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.viewModel?.updateSettings(data: FlickrViewModelSettings(data: nil, isSearchModeActive: false))
    }
}
