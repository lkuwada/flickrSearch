//
//  PhotosCollectionViewController.swift
//  SearchFlickr
//
//  Created by Lynden Kuwada on 11/18/18.
//  Copyright © 2018 Lynden Kuwada. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"
private let itemsPerRow:CGFloat = 3.0

class PhotosCollectionViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    let flickrSearch = FlickrSearch()
    var searchResults = [FlickrPhoto]()
    private var currentTerm: String = ""
    fileprivate var page = 1
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = self.searchResults[indexPath.row]
        cell.backgroundColor = UIColor.white
        cell.imageView.image = photo.thumbnail
        
        return cell
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let term = textField.text else {
            return true
        }
        page = 1
        currentTerm = term
        if searchResults.count > 0 {
            self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            searchResults = [FlickrPhoto]()
            self.collectionView?.reloadData()
        }
        
        flickrSearch.searchForTerm(term: term, page: page) { photos in
            if let photos = photos {
                self.searchResults = photos
                self.collectionView?.reloadData()
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
